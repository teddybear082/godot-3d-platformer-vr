extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var countdown = 60
var player = null
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent().get_node("player/FPController")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	countdown -= 1
	if countdown <= 0:
		global_transform.origin = player.global_transform.origin
		countdown = 60
