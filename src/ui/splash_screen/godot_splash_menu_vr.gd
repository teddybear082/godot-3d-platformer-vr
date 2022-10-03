extends Spatial

onready var main_scene = preload("res://src/ui/main_menu/main_menu_vr.tscn")
### Signals ###
signal change_scene_request(target_scene_res_path)



# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(7), "timeout")
	emit_signal("change_scene_request", "res://src/ui/main_menu/main_menu_vr.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
