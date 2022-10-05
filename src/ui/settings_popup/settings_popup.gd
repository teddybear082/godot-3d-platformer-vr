#class_name
extends Popup
# Docstring


### Signals ###

### Enums ###

### Constants ###

### Exported variables ###

### Public variables ###

### Private variables ###

### Onready variables ###
onready var _slider_audio_master: HSlider = find_node("SliderAudioMaster", true)
onready var _slider_audio_sfx: HSlider = find_node("SliderAudioSFX", true)
onready var _slider_audio_music: HSlider = find_node("SliderAudioMusic", true)
onready var _snap_turn_button : CheckButton = find_node("SnapTurnCheckButton", true)
onready var _teleport_check_button : CheckButton = find_node("TeleportCheckButton", true)
#onready var _slider_mouse_sensitivity: HSlider = find_node("SliderMouseSense", true)
#onready var _slider_gamepad_sensitivity: HSlider = find_node("SliderPadSense", true)


############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	_slider_audio_master.set_value(UserData.audio_vol_master)
	_slider_audio_sfx.set_value(UserData.audio_vol_sfx)
	_slider_audio_music.set_value(UserData.audio_vol_music)
	_snap_turn_button.pressed = UserData.use_snap_turn
	_teleport_check_button.pressed = UserData.use_teleport
	#_slider_mouse_sensitivity.set_value(UserData.mouse_sensitivity)
	#_slider_gamepad_sensitivity.set_value(UserData.gamepad_sensitivity)


############################
#      Public Methods      #
############################



############################
# Signal Connected Methods #
############################
func _on_btn_back_pressed() -> void:
	set_visible(false)
	UserData.save_to_disk()


func _on_slider_audio_master_value_changed(value: float) -> void:
	UserData.audio_vol_master = value
	if value == 0:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0, _vol_linear_to_db(value))


func _on_slider_audio_sfx_value_changed(value: float) -> void:
	UserData.audio_vol_sfx = value
	if value == 0:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
		AudioServer.set_bus_volume_db(1, _vol_linear_to_db(value))


func _on_sider_audio_music_value_changed(value: float) -> void:
	UserData.audio_vol_music = value
	if value == 0:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		AudioServer.set_bus_volume_db(2, _vol_linear_to_db(value))


#func _on_slider_mouse_sense_value_changed(value: float) -> void:
#	UserData.set_mouse_sensitivity(value)


#func _on_slider_pad_sense_value_changed(value: float) -> void:
#	UserData.set_gamepad_sensitivity(value)


############################
#      Private Methods     #
############################
func _vol_db_to_linear(val: float) -> float:
	return db2linear(val - 6)


func _vol_linear_to_db(val: float) -> float:
	return linear2db(val) + 6


func _on_SnapTurnCheckButton_pressed():
	UserData.use_snap_turn = _snap_turn_button.pressed 


func _on_TeleportCheckButton_pressed():
	UserData.use_teleport = _teleport_check_button.pressed
