#class_name PlayerStateDead
extends PlayerState
# Docstring


############################
#      Public Methods      #
############################

# Corresponds to the _physics_process() callback
func physics_update(delta: float) -> void:
	.physics_update(delta)
	
	_apply_xz_movement(delta, Vector3.ZERO)
	_apply_pushed_impulse_velocity()
	
	_player.velocity.y = max(
				_player.velocity.y + (_player.gravity_acceleration_fall * delta),
				_player.max_speed_fall
		)
	
	_player.velocity = _player.move_and_slide_with_snap(
			_player.velocity, _player.snap_vector,  Vector3.UP, true,
			4, deg2rad(_player.floor_max_angle_deg)
	)


func enter(_data := {}) -> void:
	_player.set_collision_shape(_player.COLLISION_SHAPES.DEAD)
	_animate()


func exit() -> void:
	pass


############################
#      Private Methods     #
############################
func _animate() -> void:
	_animation_state_machine.travel("fallover")


func _update_state() -> void:
	pass

