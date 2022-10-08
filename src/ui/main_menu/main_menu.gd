#class_name
extends Control
# Docstring


### Signals ###
signal change_scene_request(target_scene_res_path)
signal play_menu_click
signal show_keyboard
signal name_entered(new_name)
### Enums ###

### Constants ###

### Exported variables ###

### Public variables ###

### Private variables ###
var _level_select_scene_path: String = "res://src/ui/level_select/menu_level_select_vr.tscn"
var _options_scene_path: String = ""
var _controls_scene_path: String = ""

### Onready variables ###


############################
# Engine Callback Methods  #
############################

func _init() -> void:
	pass


func _ready() -> void:
	find_node("EnterNameLineEdit").text = UserData.user_name


func _input(_event: InputEvent) -> void:
	pass


func _process(_delta: float) -> void:
	pass


############################
#      Public Methods      #
############################



############################
# Signal Connected Methods #
############################

func _on_btn_level_pressed() -> void:
	emit_signal("play_menu_click")
	emit_signal("change_scene_request", _level_select_scene_path)


func _on_btn_settings_pressed() -> void:
	emit_signal("play_menu_click")
	$SettingsPopup.popup()


func _on_btn_controls_pressed() -> void:
	emit_signal("play_menu_click")
	$ControlsPopup.popup()


func _on_btn_exit_pressed() -> void:
	emit_signal("play_menu_click")
	get_tree().quit()



func _on_BtnCredits_pressed() -> void:
	emit_signal("play_menu_click")
	$CreditsPopup.popup()
	

func _on_SettingsPopup_play_menu_click():
	emit_signal("play_menu_click")


func _on_ControlsPopup_play_menu_click():
	emit_signal("play_menu_click")
	

func _on_CreditsPopup_play_menu_click():
	emit_signal("play_menu_click")



func _on_LeaderboardPopup_play_menu_click():
	emit_signal("play_menu_click")


func _on_BtnLeaderboard_pressed():
	emit_signal("play_menu_click")
	$LeaderboardPopup.popup()



############################
#      Private Methods     #
############################


func _on_EnterNameLineEdit_focus_entered():
	emit_signal("show_keyboard")


func _on_EnterNameLineEdit_text_entered(new_text):
	emit_signal("name_entered", new_text) 
