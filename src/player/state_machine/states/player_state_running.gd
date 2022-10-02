#class_name PlayerStateRunning
extends PlayerState
# Docstring


############################
#      Public Methods      #
############################
# Corresponds to _unhandled_input() callback
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_jump"):
		emit_signal("change_state_request", "Jumping")
	elif event.is_action_pressed("player_roll"):
		emit_signal("change_state_request", "Roll")


# Corresponds to the _physics_process() callback
func physics_update(delta: float) -> void:
	.physics_update(delta)
	
	var movement_direction_xz := _get_input_movement_direction_xz()
	_apply_xz_movement(delta, movement_direction_xz)
	if movement_direction_xz != Vector3.ZERO:
		_rotate_body(delta, movement_direction_xz)
	
	_apply_pushed_impulse_velocity()
	_apply_gravity(delta)
	
	_player.velocity = _player.move_and_slide_with_snap(
			_player.velocity, _player.snap_vector,  Vector3.UP, true,
			4, deg2rad(_player.floor_max_angle_deg)
	)


func enter(_data := {}) -> void:
	_player.set_collision_shape(_player.COLLISION_SHAPES.STANDING)
	_animate()
	_player.frames_since_on_floor = 0
	_player.can_double_jump = true


func exit() -> void:
	pass


############################
#      Private Methods     #
############################
func _animate() -> void:
	_animation_state_machine.travel("running")


func _update_state() -> void:
	var target_state_id := name
	if not _player.is_on_floor():
		target_state_id = "InAir"
	elif _get_input_movement_direction_xz() == Vector3.ZERO:
		target_state_id = "Idle"

	if target_state_id != name:
		emit_signal("change_state_request", target_state_id, {})
