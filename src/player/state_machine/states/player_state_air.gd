#class_name PlayerStateAir
extends PlayerState
# Docstring


############################
#      Public Methods      #
############################
# Corresponds to _unhandled_input() callback
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_jump"):
		var can_coyote_jump: bool = _player.frames_since_on_floor <= _player.coyote_frames
		if can_coyote_jump:
			emit_signal("change_state_request", "Jumping")
		elif _player.can_double_jump:
			emit_signal("change_state_request", "DoubleJump")


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
	_animate()


func exit() -> void:
	pass


############################
#      Private Methods     #
############################
func _animate() -> void:
	_animation_state_machine.travel("falling")


func _update_state() -> void:
	_player.set_collision_shape(_player.COLLISION_SHAPES.STANDING)
	var target_state_id := name
	if _player.is_on_floor():
		if _get_input_movement_direction_xz() != Vector3.ZERO:
			target_state_id = "Running"
		else:
			target_state_id = "Idle"
	
	if target_state_id != name:
		emit_signal("change_state_request", target_state_id, {})


func _apply_gravity(delta: float) -> void:
	if _player.velocity.y < 0:
		_player.velocity.y = max(
				_player.velocity.y + (_player.gravity_acceleration_fall * delta),
				_player.max_speed_fall
		)
	else:
		_player.velocity.y = max(
				_player.velocity.y + (_player.gravity_acceleration_jump * delta),
				_player.max_speed_fall
		)
