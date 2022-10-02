extends PlayerState
# Docstring

### Exported variables ###
export(Animation) var _roll_animation: Animation


### Private variables ###
var _roll_direction: Vector3
var _roll_velocity: Vector3
var _can_spin_jump: bool
var _spin_jump_input_recieved: bool


### Onready variables ###
onready var _can_spin_jump_timer: Timer = get_node("Timer")


############################
#      Public Methods      #
############################
# Corresponds to _unhandled_input() callback
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_jump"):
		_spin_jump_input_recieved = true
		if _can_spin_jump:
			emit_signal("change_state_request", "SpinJump")


# Corresponds to the _physics_process() callback
func physics_update(delta: float) -> void:
	_update_snap_vector()
	_rotate_body(delta, _roll_direction)
	
	_player.velocity.x = _roll_velocity.x
	_player.velocity.z = _roll_velocity.z

	_apply_pushed_impulse_velocity()
	_apply_gravity(delta)

	_player.velocity = _player.move_and_slide_with_snap(
			_player.velocity, _player.snap_vector,  Vector3.UP, true,
			4, deg2rad(_player.floor_max_angle_deg)
	)


func enter(_data := {}) -> void:
	_spin_jump_input_recieved = false
	_can_spin_jump = false
	_can_spin_jump_timer.start()
	_roll_direction = _get_input_movement_direction_xz()
	if _roll_direction == Vector3.ZERO:
		_roll_direction = Vector3.FORWARD.rotated(
			Vector3.UP, 
			_player.camera_system.get_camera_global_transform().basis.get_euler().y
		)
	_roll_velocity = _roll_direction * target_speed_xz
	
	_player.set_collision_shape(_player.COLLISION_SHAPES.ROLL)
	_animate()
	yield(get_tree().create_timer(_roll_animation.length, false), "timeout")
	_update_state()


func exit() -> void:
	pass


############################
#      Private Methods     #
############################
func _animate() -> void:
	_animation_state_machine.travel("roll")


func _update_state() -> void:
	var target_state_id := name
	if not _player.is_on_floor():
		target_state_id = "InAir"
	elif _get_input_movement_direction_xz() != Vector3.ZERO:
		target_state_id = "Running"
	elif _get_input_movement_direction_xz() == Vector3.ZERO:
		target_state_id = "Idle"

	if target_state_id != name:
		emit_signal("change_state_request", target_state_id, {})


func _on_spin_jump_timer_timeout() -> void:
	if _spin_jump_input_recieved:
		emit_signal("change_state_request", "SpinJump")
	else:
		_can_spin_jump = true
