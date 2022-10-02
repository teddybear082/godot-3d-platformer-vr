#class_name
extends Spatial
# Docstring


### Signals ###

### Enums ###

### Constants ###

### Exported variables ###
export(float, -10, 10) var tangential_velocity: float = 1.0
export(float) var diameter: float

### Public variables ###

### Private variables ###
var _angular_velocity: float

### Onready variables ###
onready var _pipe: KinematicBody = get_node("KinematicBody")


############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	_angular_velocity = tangential_velocity / (diameter * 0.5)


func _physics_process(_delta: float) -> void:
	_pipe.rotate_z(_angular_velocity * _delta)


############################
#      Public Methods      #
############################



############################
# Signal Connected Methods #
############################



############################
#      Private Methods     #
############################
