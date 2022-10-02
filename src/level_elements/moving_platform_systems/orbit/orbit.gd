tool
#class_name PhysicsPlatformSystemOrbit
extends Spatial
# Docstring


### Signals ###

### Enums ###

### Constants ###

### Exported variables ###
export(float) var tangential_velocity: float = 1.0
export(float, 1, 100) var orbit_radius: float = 10 setget _set_orbit_radius
export(float, -1, 1) var orbit_direction: float = 1 setget _set_orbit_direction

### Public variables ###

### Private variables ###
var _angular_velocity: float

### Onready variables ###
onready var _orbit_root: Spatial = get_node("Root")
onready var _orbit_root_marker: MeshInstance = get_node("Root/RootMarker")
onready var _platform: MovingPlatform = get_node("Root/MovingPlatform")
onready var _radius_line: ImmediateGeometry = get_node("Root/RadiusLine")
onready var _direction_line: ImmediateGeometry = get_node("Root/MovingPlatform/DirectionLine")


############################
# Engine Callback Methods  #
############################

func _ready() -> void:
	_angular_velocity  = tangential_velocity / orbit_radius
	_platform.set_translation(Vector3(orbit_radius, 0, 0))
	_update_immediate_geometry()
	
	_orbit_root_marker.set_visible(Engine.editor_hint)
	_radius_line.set_visible(Engine.editor_hint)
	_direction_line.set_visible(Engine.editor_hint)
	
	if not Engine.editor_hint:
		_platform.angular_velocity_y = _angular_velocity * orbit_direction


func _physics_process(_delta: float) -> void:
	if not Engine.editor_hint:
		_orbit_root.rotate_y(_angular_velocity * orbit_direction * _delta)


############################
#      Public Methods      #
############################


############################
# Signal Connected Methods #
############################



############################
#      Private Methods     #
############################
func _set_orbit_radius(val: float) -> void:
	orbit_radius = val
	if Engine.editor_hint && is_inside_tree():
		_platform.set_translation(Vector3(orbit_radius, 0, 0))
		_update_immediate_geometry()


func _set_orbit_direction(val: float) -> void:
	orbit_direction = sign(val)
	if orbit_direction == 0:
		orbit_direction = 1
	if Engine.editor_hint && is_inside_tree():
		_update_immediate_geometry()


func _update_immediate_geometry() -> void:
	if Engine.editor_hint && is_inside_tree():
		_radius_line.clear()
		_radius_line.begin(Mesh.PRIMITIVE_LINES)
		_radius_line.set_color(Color(1,0,1,1))
		_radius_line.add_vertex(Vector3.ZERO)
		_radius_line.add_vertex(Vector3(orbit_radius, 0, 0))
		_radius_line.end()
		
		_direction_line.clear()
		_direction_line.begin(Mesh.PRIMITIVE_LINES)
		_direction_line.set_color(Color(1,0,1,1))
		_direction_line.add_vertex(Vector3.ZERO)
		_direction_line.add_vertex(Vector3(0, 0, -orbit_direction * 4))
		_direction_line.end()
