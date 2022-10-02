#class_name
extends Control
# Script controlling the level select menu screen


### Signals ###
signal change_scene_request(target_scene_res_path)

### Exported variables ###
export(String) var _level_directory_path: String

### Onready variables ###
onready var _level_button_container: HBoxContainer = get_node("Panel/VBoxContainer/LevelButtons/HBoxContainer")
onready var _level_button_res := preload("res://src/ui/level_select/level_button/level_button.tscn")

onready var _score_label: Label = find_node("ScoreStat", true).get_node("Value")
onready var _time_label: Label = find_node("TimeStat", true).get_node("Value")
onready var _coin_label: Label = find_node("CoinStat", true).get_node("Value")
onready var _extra_label: Label = find_node("ExtraStat", true).get_node("Value")
onready var _death_label: Label = find_node("DeathStat", true).get_node("Value")


############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_add_level_buttons(_find_level_file_names())


############################
# Signal Connected Methods #
############################
func _on_btn_back_pressed() -> void:
	emit_signal(
			"change_scene_request", 
			"res://src/ui/main_menu/main_menu_vr.tscn"
	)


func _on_level_button_pressed(button: LevelButton) -> void:
	var level_res_path := (
			"res://src/levels/%s.tscn" % 
			button.text.replace(" ", "_").to_lower()
	)
	emit_signal("change_scene_request", level_res_path)


func _on_level_button_mouse_entered(button: LevelButton) -> void:
	$Panel/VBoxContainer/Stats/VBoxContainer/Title.set_text(
			"-- Level %s High Score Stats --" % button.get_text()
	)
	var level_file_name := button.get_text().to_lower().replace(" ", "_")
	var level_best_data := SaveLoad.load_level_best(level_file_name)
	
	if level_best_data.size() > 0:
		_coin_label.set_text(
				str(level_best_data["coins_collected"]) + "/" + str(level_best_data["coins_total"])
		)
		_extra_label.set_text(
				str(level_best_data["optionals_collected"]) + "/" + str(level_best_data["optionals_total"])
		)
		_score_label.set_text(str(level_best_data["score"]))
		_time_label.set_text(GenUtils.format_time_minutes_seconds(level_best_data["time"]))
		_death_label.set_text(str(level_best_data["player_death_count"]))
	else:
		_coin_label.set_text("##/##")
		_extra_label.set_text("##/##")
		_score_label.set_text("####")
		_time_label.set_text("##:##")
		_death_label.set_text("##")


############################
#      Private Methods     #
############################
func _find_level_file_names() -> PoolStringArray:
	var result: PoolStringArray = []
	var dir := Directory.new()
	var err := dir.open(_level_directory_path)
	if err == OK:
		var regex := RegEx.new()
		var match_string = "level_\\d+.tscn"
		err = regex.compile(match_string)
		if err == OK:
			# warning-ignore:return_value_discarded
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if not dir.current_is_dir():
					if regex.search(file_name):
						result.append(file_name)
				file_name = dir.get_next()
		else:
			print("Error %d : Failed compile RegEx %s" % [err, match_string])
	else:
		print("Error %d : Failed to open directory %s" % [err, _level_directory_path])
	return result


func _add_level_buttons(level_file_names: PoolStringArray) -> void:
	for i in range(level_file_names.size()):
		var file_name: String = level_file_names[i]
		var new_button = _level_button_res.instance()
		_level_button_container.add_child(new_button)
		new_button.set_v_size_flags(SIZE_EXPAND_FILL)
		new_button.set_custom_minimum_size(Vector2(200, 0))
		var text := file_name.get_basename().capitalize()
		new_button.set_text(text)
		new_button.set_name("Button%s" % text.replace(" ", ""))
		
		if !(UserData.is_level_0_complete) && (text != "Level 0"):
			new_button.set_disabled(true)
		
		GenUtils.connect_signal_assert_ok(
				new_button, "level_button_pressed",
				self, "_on_level_button_pressed"
		)
		GenUtils.connect_signal_assert_ok(
				new_button, "level_button_mouse_entered",
				self, "_on_level_button_mouse_entered"
		)
