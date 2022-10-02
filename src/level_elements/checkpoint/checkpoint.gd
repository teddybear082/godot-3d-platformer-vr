class_name Checkpoint
extends Area
# Docstring


### Signals ###
signal checkpoint_entered(checkpoint)

### Enums ###

### Constants ###

### Exported variables ###

### Public variables ###

### Private variables ###
var _bulb_materials := {
		"inactive": preload("res://src/level_elements/checkpoint/bulb_inactive.material"),
		"active": preload("res://src/level_elements/checkpoint/bulb_active.material")
}
var _is_active := false

### Onready variables ###
onready var _mesh_inst: MeshInstance = get_node("MeshInstance")


############################
# Engine Callback Methods  #
############################

func _init() -> void:
	pass


func _ready() -> void:
	deactivate()


func _input(_event: InputEvent) -> void:
	pass


func _process(_delta: float) -> void:
	pass


############################
#      Public Methods      #
############################
func activate() -> void:
	_set_bulb_material("active")
	_is_active = true


func deactivate() -> void:
	_set_bulb_material("inactive")
	_is_active = false



############################
# Signal Connected Methods #
############################
func _on_body_entered(body: PhysicsBody):
	if body.get_parent().get_parent().get_parent().is_in_group("Player"):
		if not _is_active:
			get_node("AudioStreamPlayer").play()
			emit_signal("checkpoint_entered", self)
			_is_active = true



############################
#      Private Methods     #
############################
func _set_bulb_material(mat_id: String) -> void:
	assert(_bulb_materials.has(mat_id))
	_mesh_inst.set_surface_material(0, _bulb_materials[mat_id])
