#class_name
extends Particles
# Docstring


### Signals ###

### Enums ###

### Constants ###

### Exported variables ###
export(float) var max_distance: float = 100

### Public variables ###
var direction: Vector3 = Vector3.FORWARD
var speed: float = 0.8
var distance_traveled_squared: float

### Private variables ###

### Onready variables ###
onready var initial_position: Vector3 = global_transform.origin
onready var max_distance_squared: float = pow(max_distance, 2)


############################
# Engine Callback Methods  #
############################

func _physics_process(delta: float) -> void:
	var distance_step: Vector3 = direction * speed * delta
	distance_traveled_squared += distance_step.length_squared()
	if distance_traveled_squared > max_distance_squared:
		global_transform.origin = initial_position
	else:
		global_translate(distance_step)


############################
#      Public Methods      #
############################



############################
# Signal Connected Methods #
############################



############################
#      Private Methods     #
############################
