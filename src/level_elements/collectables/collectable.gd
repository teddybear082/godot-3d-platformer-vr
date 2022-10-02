class_name Collectable
extends Area
# Docstring


### Signals ###
signal collected(object_name, value)

### Enums ###

### Constants ###

### Exported variables ###
export(SpatialMaterial) var _collected_material: SpatialMaterial
export(int) var _value := 2 setget ,get_value
export(float, 0.5, 10) var _rotation_speed := 1.0

### Public variables ###

### Private variables ###
var _is_collected := false

### Onready variables ###
onready var _anim_player: AnimationPlayer =  get_node("AnimationPlayer")


############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	rotate_y(randi() % 90)


func _physics_process(delta: float) -> void:
	rotate_y(_rotation_speed * delta)


############################
#      Public Methods      #
############################
func get_value() -> int:
	return _value


func apply_collected_material() -> void:
	var mesh_inst: MeshInstance = $MeshInstance
	for surface in range(mesh_inst.get_surface_material_count()):
		mesh_inst.set_surface_material(surface, _collected_material)


############################
# Signal Connected Methods #
############################
func _on_body_entered(_body: PhysicsBody):
	if not _is_collected:
		emit_signal("collected", name, _value)
		_is_collected = true
		_anim_player.play("pickup")
		yield(_anim_player, "animation_finished")
		queue_free()
