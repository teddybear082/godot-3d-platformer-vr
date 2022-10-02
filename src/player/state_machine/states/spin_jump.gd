extends PlayerState
# Docstring

### Exported variables ###
export(Animation) var _animation: Animation


### Private variables ###
var _jump_direction: Vector3
var _jump_velocity: Vector3


### Onready variables ###
onready var _audio_jump: AudioStreamPlayer = get_node("AudioStreamJump")


############################
#      Public Methods      #
############################

# Corresponds to the _physics_process() callback
func physics_update(delta: float) -> void:
	_player.snap_vector = Vector3.ZERO
	
	_player.velocity = _jump_velocity
	
	#_apply_pushed_impulse_velocity()
	_apply_gravity(delta)
	
	_player.velocity = _player.move_and_slide_with_snap(
			_player.velocity, _player.snap_vector,  Vector3.UP, true,
			4, deg2rad(_player.floor_max_angle_deg)
	)


func enter(_data := {}) -> void:
	_jump_direction = _player.velocity
	_jump_direction.y = 0
	_jump_direction = _jump_direction.rotated(
			_player.global_transform.basis.x, -45
	)
	_jump_velocity = _jump_direction.normalized() * target_speed_xz
	
	_player.set_collision_shape(_player.COLLISION_SHAPES.SPIN_JUMP)
	_animate()
	yield(get_tree().create_timer(_animation.length, false), "timeout")
	_update_state()


func exit() -> void:
	pass


############################
#      Private Methods     #
############################
func _animate() -> void:
	_animation_state_machine.travel("spin_jump")
	_audio_jump.play()


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
