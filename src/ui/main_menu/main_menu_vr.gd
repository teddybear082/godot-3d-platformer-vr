extends Spatial

### Signals ###
signal change_scene_request(target_scene_res_path)

onready var main_menu_viewport_scene = $main_menu_viewport.scene_node

func _ready():
	main_menu_viewport_scene.connect("change_scene_request", self, "change_scene_request_signal_received")
	main_menu_viewport_scene.connect("play_menu_click", self, "_on_play_menu_click")
	
func change_scene_request_signal_received(target_scene_res_path):
	emit_signal("change_scene_request", target_scene_res_path)

func _on_play_menu_click():
	$MenuSounds.play()
