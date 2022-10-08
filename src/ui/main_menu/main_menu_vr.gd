extends Spatial

### Signals ###
signal change_scene_request(target_scene_res_path)

onready var main_menu_viewport_scene = $main_menu_viewport.scene_node
onready var virtual_keyboard = $Virtual_Keyboard

func _ready():
	main_menu_viewport_scene.connect("change_scene_request", self, "change_scene_request_signal_received")
	main_menu_viewport_scene.connect("play_menu_click", self, "_on_play_menu_click")
	main_menu_viewport_scene.connect("show_keyboard", self, "_on_show_keyboard")
	main_menu_viewport_scene.connect("name_entered", self, "_on_name_entered") 


func change_scene_request_signal_received(target_scene_res_path):
	emit_signal("change_scene_request", target_scene_res_path)

func _on_play_menu_click():
	if !$MenuSounds.playing:
		$MenuSounds.play()

func _on_show_keyboard():
	virtual_keyboard.visible = true
	
func _on_name_entered(new_name):
	UserData.set_user_name(new_name)
	main_menu_viewport_scene.find_node("EnterNameLabel").text = "Name Entered!"
	virtual_keyboard.visible = false
	yield(get_tree().create_timer(3), "timeout")
	main_menu_viewport_scene.find_node("EnterNameLabel").text = "Enter name for leaderboards:"
