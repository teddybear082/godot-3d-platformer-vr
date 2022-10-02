#class_name
extends Spatial
# Docstring


### Signals ###

### Enums ###

### Constants ###

### Exported variables ###
export(float, -40, 40) var angular_velocity: float = 10

### Public variables ###

### Private variables ###

### Onready variables ###
onready var _platform: MovingPlatform = get_node("MovingPlatform")


############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	_platform.angular_velocity_y = deg2rad(angular_velocity)


func _physics_process(delta: float) -> void:
	_platform.rotate_y(deg2rad(angular_velocity) * delta)


############################
#      Public Methods      #
############################



############################
# Signal Connected Methods #
############################



############################
#      Private Methods     #
############################
