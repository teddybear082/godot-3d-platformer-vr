extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var left_controller = get_parent().get_node("FPController/LeftHandController")
onready var right_controller= get_parent().get_node("FPController/RightHandController")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Left_Function_Pickup_has_picked_up(what):
	left_controller.set_rumble(.3)
	yield(get_tree().create_timer(.2, false), "timeout")
	left_controller.set_rumble(0.0)
	# Replace with function body.


func _on_Function_Pickup_has_picked_up(what):
	right_controller.set_rumble(.3)
	yield(get_tree().create_timer(.2, false), "timeout")
	right_controller.set_rumble(0.0)
