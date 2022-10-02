tool
#class_name PhysicsPlatformSystemFollowPath
extends Spatial
# Docstring


### Signals ###

### Enums ###

### Constants ###

### Exported variables ###
export(Material) var _point_material_default: Material
export(int) var _point_count: int = 2 setget _set_point_count
export(bool) var _close_loop: bool = false setget _set_close_loop

### Public variables ###

### Private variables ###
var _points: Array
var _current_point_index: int = 0
var _current_path_direction: int = 1
var _next_point_index: int = _current_point_index + _current_path_direction

### Onready variables ###
onready var _platform: MovingPlatform = get_node("MovingPlatform")
onready var _tween: Tween = get_node("Tween")
onready var _closed_loop_line: ImmediateGeometry = get_node("ClosedLoopLine")
onready var _point_res: PackedScene = preload("res://src/level_elements/moving_platform_systems/follow_path/point.tscn")


############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	_find_current_points()
	if Engine.editor_hint:
		if !(get_parent() is Viewport):
			while _points.size() < _point_count:
				_add_point()
		
		_update_immediate_geometry()
	else:
		_platform.global_transform.origin = _points[0].global_transform.origin
		_tween_to_next_point()
	
	_platform.set_visible(not Engine.editor_hint)
	_closed_loop_line.set_visible(Engine.editor_hint)
	for point in _points:
		point.set_visible(Engine.editor_hint)


############################
#      Public Methods      #
############################


############################
# Signal Connected Methods #
############################
func _on_point_local_position_changed() -> void:
	_update_immediate_geometry()


############################
#      Private Methods     #
############################

func _find_current_points() -> void:
	for child in get_children():
		if child is MovingPlatformSystemFollowPathPoint:
			var point: MovingPlatformSystemFollowPathPoint = child
			_points.append(point)
			
			point.set_mesh($MovingPlatform/MeshInstance.get_mesh())
			point.set_surface_material(_point_material_default)
			if _points.size() == 1:
				point.previous_point = null
				point.set_surface_material(
						_platform.get_node("MeshInstance").get_surface_material(0)
				)
			else:
				var previous_point_index: int = _points.size() - 2
				var previous_point: MovingPlatformSystemFollowPathPoint = _points[previous_point_index]
				point.previous_point = previous_point
			var err := point.connect("local_position_changed", self, "_on_point_local_position_changed")
			assert(err == OK)


func _add_point() -> void:
	if Engine.editor_hint && is_inside_tree():
		var point: MovingPlatformSystemFollowPathPoint = _point_res.instance()
		add_child(point)
		point.set_owner(get_tree().edited_scene_root)
		_points.append(point)
		
		point.set_mesh($MovingPlatform/MeshInstance.get_mesh())
		point.set_surface_material(_point_material_default)
		if _points.size() == 1:
			point.previous_point = null
			point.set_surface_material(
					_platform.get_node("MeshInstance").get_surface_material(0)
			)
		else:
			var previous_point_index: int = _points.size() - 2
			var previous_point: MovingPlatformSystemFollowPathPoint = _points[previous_point_index]
			point.previous_point = previous_point
			point.set_translation(previous_point.translation)
		var err := point.connect("local_position_changed", self, "_on_point_local_position_changed")
		assert(err == OK)
		_update_immediate_geometry()


func _set_point_count(value: int) -> void:
	if Engine.editor_hint:
		_point_count = int(max(2, value))
		if _point_count > _points.size():
			for _i in range(value - _points.size()):
				_add_point()
		elif _point_count < _points.size():
			for _i in range(_points.size() - value):
				var point = _points.pop_back()
				point.queue_free()
		_update_immediate_geometry()


func _get_point(index: int) -> MovingPlatformSystemFollowPathPoint:
	return _points[index]


func _set_close_loop(val: bool) -> void:
	_close_loop = val
	_update_immediate_geometry()


func _update_immediate_geometry() -> void:
	if Engine.editor_hint && is_inside_tree():
		for point in _points:
			point.update_immediate_geometry()
	
		_closed_loop_line.clear()
		if _close_loop:
			_closed_loop_line.begin(Mesh.PRIMITIVE_LINES)
			_closed_loop_line.set_color(Color(1,0,1,1))
			_closed_loop_line.add_vertex(_points[0].transform.origin)
			_closed_loop_line.add_vertex(_points[-1].transform.origin)
			_closed_loop_line.end()


func _tween_to_next_point() -> void:
	var current_point: MovingPlatformSystemFollowPathPoint = _get_point(_current_point_index)
	var next_point: MovingPlatformSystemFollowPathPoint = _get_point(_next_point_index)
	var translation_target := next_point.translation
	var translation_length := (translation_target - _platform.translation).length()
	var platform_speed: float
	if _current_path_direction == 1:
		platform_speed = current_point.section_speed
	else:
		platform_speed = next_point.section_speed
	var duration: float = translation_length / platform_speed

	var bool_res := _tween.interpolate_property(
			_platform, "translation", 
			_platform.translation, translation_target,
			duration, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN,
			current_point.wait_time
	)
	assert(bool_res)
	bool_res = _tween.start()
	assert(bool_res)


func _on_tween_completed(_object: Object, _key: NodePath) -> void:
	_current_point_index = _next_point_index
	
	if _close_loop:
		_next_point_index = _current_point_index  + _current_path_direction
		if _next_point_index == _points.size():
			_next_point_index = 0
	else:
		if _current_point_index + _current_path_direction == _points.size():
			_current_path_direction = -1
		elif _current_point_index + _current_path_direction == -1:
			_current_path_direction = 1
		_next_point_index = _current_point_index + _current_path_direction
	
	_tween_to_next_point()
