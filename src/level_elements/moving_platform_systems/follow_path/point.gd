tool
class_name MovingPlatformSystemFollowPathPoint
extends Spatial
# Docstring


### Signals ###
signal local_position_changed()

### Enums ###

### Constants ###

### Exported variables ###
# Time in seconds spent being stationary at this point before moving to the next point
export(float, 0, 30) var wait_time: float = 0.5
# Platform speed for the section between this point and the one after it. 
# This parameter has no effect when set on the final point
# TODO Unless close_loop is true
export(float, 0.1, 10) var section_speed: float = 1.0

### Public variables ###
var previous_point: MovingPlatformSystemFollowPathPoint

### Private variables ###

### Onready variables ###
onready var _mesh_instance: MeshInstance = get_node("MeshInstance")
onready var _immediate_geometry: ImmediateGeometry = get_node("ImmediateGeometry")


############################
# Engine Callback Methods  #
############################


############################
#      Public Methods      #
############################
func set_mesh(mesh: Mesh) -> void:
	_mesh_instance.set_mesh(mesh)


func set_surface_material(mat: Material, surface := -1) -> void:
	if surface == -1:
		for i in range(_mesh_instance.get_surface_material_count()):
			_mesh_instance.set_surface_material(i, mat)
	else:
		_mesh_instance.set_surface_material(surface, mat)


func update_immediate_geometry() -> void:
	if previous_point:
		_immediate_geometry.clear()
		_immediate_geometry.begin(Mesh.PRIMITIVE_LINES)
		_immediate_geometry.set_color(Color(1,0,1,1))
		_immediate_geometry.add_vertex(Vector3(0, 0, 0))
		_immediate_geometry.add_vertex(to_local(previous_point.global_transform.origin))
		_immediate_geometry.end()


func set_global_transform(value: Transform) -> void:
	.set_global_transform(value)
	
	if Engine.editor_hint:
		emit_signal("local_position_changed")



############################
# Signal Connected Methods #
############################



############################
#      Private Methods     #
############################
