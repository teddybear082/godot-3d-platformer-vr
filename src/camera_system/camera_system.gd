tool
class_name CameraSystem
extends Spatial
# Docstring


### Signals ###

### Enums ###

### Constants ###

### Exported variables ###
export(Resource) var _preset_data: Resource
#export(float, 0.05, 1.0) var _sensitivity := 0.5

### Public variables ###

### Private variables ###
var _follow_target: Spatial
var _target_rotations: Vector3
#var _target_origin: Vector3
var _look_target: Vector3 # In local space

### Onready variables ###
onready var _camera: ClippedCamera = get_node("ClippedCamera")


############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	if Engine.editor_hint:
		GenUtils.connect_signal_assert_ok(
				_preset_data, "transform_value_changed", 
				self, "_t_on_preset_data_transform_value_changed"
		)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_follow_target = get_node(_preset_data.target_path)
		_camera.add_exception(_follow_target)
	
	_look_target = _preset_data.look_target_initial
	#######
	_camera.transform.origin = _preset_data.camera_offset
	_camera.look_at(to_global(_look_target), Vector3.UP)
	


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_handle_input_mouse_motion(event)
	elif event.is_action_pressed("ui_cancel"):
		_toggle_mouse_capture()


func _physics_process(_delta: float) -> void:
	if not Engine.editor_hint:
		_update_transform()
		_check_input_joy_motion()


############################
#      Public Methods      #
############################
func get_camera_global_transform() -> Transform:
	return _camera.global_transform


func set_follow_target(target: Spatial) -> void:
	_follow_target = target


############################
# Signal Connected Methods #
############################
func _t_on_preset_data_transform_value_changed() -> void:
	_follow_target = get_node(_preset_data.target_path)
	_camera = get_node("ClippedCamera")
	_camera.clear_exceptions()
	_camera.add_exception(_follow_target)
	_look_target = _preset_data.look_target_initial
	
	set_rotation_degrees(_follow_target.rotation_degrees + _preset_data.anchor_rotation)
	_update_transform()


############################
#      Private Methods     #
############################
func _update_transform() -> void:
	global_transform.origin = lerp(
			global_transform.origin,
			_follow_target.global_transform.origin + _preset_data.anchor_offset, 
			_preset_data.follow_smoothing
	)
	
	_camera.transform.origin = _preset_data.camera_offset
	_camera.look_at(to_global(_look_target), Vector3.UP)


func _handle_input_mouse_motion(event: InputEventMouseMotion) -> void:
	var last_mouse_motion := event.relative
	rotation.y -= last_mouse_motion.x * 0.01 * UserData.mouse_sensitivity
	
	rotation.x -= last_mouse_motion.y * 0.01 * UserData.mouse_sensitivity
	rotation.x = clamp(
			rotation.x, _preset_data.pitch_limits.x, _preset_data.pitch_limits.y
	)


func _check_input_joy_motion() -> void:
	rotation.y -= Input.get_joy_axis(0, JOY_ANALOG_RX) * 0.1 * UserData.gamepad_sensitivity

	rotation.x -= Input.get_joy_axis(0, JOY_ANALOG_RY) * 0.1 * UserData.gamepad_sensitivity
	rotation.x = clamp(
			rotation.x, _preset_data.pitch_limits.x, _preset_data.pitch_limits.y
	)


func _toggle_mouse_capture() -> void:
	if get_tree().is_paused():
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
