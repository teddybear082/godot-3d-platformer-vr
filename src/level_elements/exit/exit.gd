class_name LevelExit
extends StaticBody
# Docstring


### Signals ###
signal player_entered(_level_exit)

### Enums ###

### Constants ###

### Exported variables ###

### Public variables ###

### Private variables ###
var _is_active := false setget set_active

### Onready variables ###
onready var _area: Area = get_node("Area")
onready var _particles: Particles = get_node("Particles")


############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	set_active(false)


############################
#      Public Methods      #
############################
func set_active(val: bool) -> void:
	_is_active = val
	_area.set_monitoring(val)
	_particles.set_emitting(val)


############################
# Signal Connected Methods #
############################
func _on_body_entered(body: PhysicsBody) -> void:
	if body.get_parent().get_parent().get_parent().is_in_group("Player"):
		emit_signal("player_entered", self)



############################
#      Private Methods     #
############################
