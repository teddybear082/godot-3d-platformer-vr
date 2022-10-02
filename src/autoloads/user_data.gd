extends Node
# Autoloaded script to contain user preferences

var is_level_0_complete: bool

var mouse_sensitivity: float = 0.5 setget set_mouse_sensitivity
var gamepad_sensitivity: float = 0.5 setget set_gamepad_sensitivity

var audio_vol_master: float = 0.5 setget set_audio_vol_master
var audio_vol_music: float = 0.5 setget set_audio_vol_music
var audio_vol_sfx: float = 0.5 setget set_audio_vol_sfx


func _ready() -> void:
	var data: Dictionary = SaveLoad.load_user_data()
	
	is_level_0_complete = data["is_level_0_complete"]

	mouse_sensitivity = data["mouse_sensitivity"]
	gamepad_sensitivity = data["gamepad_sensitivity"]

	audio_vol_master = data["audio_vol_master"]
	audio_vol_music = data["audio_vol_music"]
	audio_vol_sfx = data["audio_vol_sfx"]


func set_mouse_sensitivity(val: float) -> void:
	mouse_sensitivity = clamp(val, 0.05, 1.0)


func set_gamepad_sensitivity(val: float) -> void:
	gamepad_sensitivity = clamp(val, 0.05, 1.0)


func set_audio_vol_master(val: float) -> void:
	audio_vol_master = clamp(val, 0, 1.0)


func set_audio_vol_music(val: float) -> void:
	audio_vol_music = clamp(val, 0, 1.0)


func set_audio_vol_sfx(val: float) -> void:
	audio_vol_sfx = clamp(val, 0, 1.0)


func save_to_disk() -> void:
	var data: Dictionary = {
		"is_level_0_complete": is_level_0_complete,
		"mouse_sensitivity": mouse_sensitivity,
		"gamepad_sensitivity": gamepad_sensitivity,
		"audio_vol_master": audio_vol_master,
		"audio_vol_music": audio_vol_music,
		"audio_vol_sfx": audio_vol_sfx,
	}
	SaveLoad.save_user_data(data)
