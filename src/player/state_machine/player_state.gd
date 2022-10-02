class_name PlayerState
extends State
# Generic state for the player which should be extended to specific states

### Exported variables ###
export(float) var target_speed_xz := 1.0
export(float) var acceleration_xz := 1.0
export(float) var friction_xz := 1.0
export(float) var acceleration_body_rotation := 1.0

### Private variables ###
var _player: Player
var _animation_state_machine: AnimationNodeStateMachinePlayback


############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	yield(owner, "ready")
	_player = owner
	_animation_state_machine = _player.get_animation_state_machine()


############################
#      Public Methods      #
############################
# Corresponds to _unhandled_input() callback
# warning-ignore:unused_argument
func handle_input(event: InputEvent) -> void:
	pass


# Corresponds to the _process() callback
# warning-ignore:unused_argument
func update(delta: float) -> void:
	pass


# Corresponds to the _physics_process() callback
# warning-ignore:unused_argument
func physics_update(delta: float) -> void:
	_update_state()
	_update_snap_vector()


func enter(_data := {}) -> void:
	_animate()


func exit() -> void:
	pass


############################
#      Private Methods     #
############################
func _update_snap_vector() -> void:
	if _player.is_on_floor():
		_player.snap_vector = -_player.get_floor_normal()
	else:
		_player.snap_vector = Vector3.ZERO


func _get_input_movement_direction_xz() -> Vector3:
	var input_vector := Vector3.ZERO
	input_vector.z = Input.get_action_strength("player_backward") - Input.get_action_strength("player_forward")
	input_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	var direction = input_vector.normalized().rotated(
			Vector3.UP, 
			_player.camera_system.get_camera_global_transform().basis.get_euler().y
	)
	return direction


func _apply_xz_movement(delta: float, direction_xz: Vector3) -> void:
	if direction_xz != Vector3.ZERO:
		var velocity_target_xz := direction_xz * target_speed_xz
		_player.velocity.x = _player.velocity.move_toward(velocity_target_xz, acceleration_xz * delta).x
		_player.velocity.z = _player.velocity.move_toward(velocity_target_xz, acceleration_xz * delta).z
	else:
		var frictioned_velocity_xz := _player.velocity.move_toward(Vector3.ZERO, friction_xz * delta)
		_player.velocity.x = frictioned_velocity_xz.x
		_player.velocity.z = frictioned_velocity_xz.z


func _rotate_body(delta: float, direction: Vector3) -> void:
	_player.rotation.y = lerp_angle(
			_player.rotation.y, atan2(direction.x, direction.z), 
			acceleration_body_rotation * delta
	)


func _apply_pushed_impulse_velocity() -> void:
	if _player.pushed_impulse_velocity != Vector3.ZERO:
		if _player.pushed_impulse_velocity.y > 0:
			_player.snap_vector = Vector3.ZERO
			
		if not is_equal_approx(_player.pushed_impulse_velocity.y, 0):
			_player.velocity.y = _player.pushed_impulse_velocity.y
		if not is_equal_approx(_player.pushed_impulse_velocity.x, 0):
			_player.velocity.x = _player.pushed_impulse_velocity.x
		if not is_equal_approx(_player.pushed_impulse_velocity.z, 0):
			_player.velocity.z = _player.pushed_impulse_velocity.z
		
		_player.pushed_impulse_velocity = Vector3.ZERO


func _apply_gravity(delta: float) -> void:
	if _player.is_on_floor() && _player.get_floor_normal().is_equal_approx(Vector3.UP):
		_player.velocity.y = max(
				_player.velocity.y + (_player.gravity_acceleration_fall * delta),
				_player.max_speed_fall
		)


func _animate() -> void:
	pass


func _update_state() -> void:
	pass
