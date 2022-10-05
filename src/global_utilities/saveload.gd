class_name SaveLoad
extends Reference

static func save_level_best(level_name: String, time: float, coins_collected: int, coins_total: int, optionals_collected: int, optionals_total: int, player_death_count: int, score: int) -> void:
	var current_data := load_level_best(level_name)
	
	var new_data := {
			"time": time, "coins_collected": coins_collected, "coins_total": coins_total,
			"optionals_collected": optionals_collected, "optionals_total": optionals_total,
			"player_death_count": player_death_count, "score": score
	}
	
	var save_file := File.new()
	if current_data.size() > 0:
		if new_data["score"] > current_data["score"]:
			var res := save_file.open("user://%s.best" % level_name, File.WRITE)
			if res == OK:
				save_file.store_string(var2str(new_data))
	else:
		var res := save_file.open("user://%s.best" % level_name, File.WRITE)
		if res == OK:
			save_file.store_string(var2str(new_data))
	save_file.close()


static func load_level_best(level_name: String) -> Dictionary:
	var data: Dictionary = {}
	var save_file := File.new()
	if save_file.file_exists("user://%s.best" % level_name):
		var res := save_file.open("user://%s.best" % level_name, File.READ)
		if res == OK:
			data = str2var(save_file.get_as_text())
	save_file.close()
	return data


static func save_level_collected_collectables(level_name: String, collected_coins: Array, collected_extras: Array) -> void:
	var save_file := File.new()
	
	var data: Dictionary
	if save_file.file_exists("user://%s.collected" % level_name):
		data = load_level_collected_collectables(level_name)
		
		for new_coin in collected_coins:
			if not data["coin"].has(new_coin):
				data["coin"].append(new_coin)
		for new_extra in collected_extras:
			if not data["extra"].has(new_extra):
				data["extra"].append(new_extra)
	else:
		data = {
			"coin": collected_coins,
			"extra": collected_extras,
		}
	
	var res := save_file.open("user://%s.collected" % level_name, File.WRITE)
	if res == OK:
		save_file.store_string(var2str(data))
	save_file.close()


static func load_level_collected_collectables(level_name: String) -> Dictionary:
	var data: Dictionary = {
		"coin": Array(),
		"extra": Array(),
	}
	
	var save_file := File.new()
	if save_file.file_exists("user://%s.collected" % level_name):
		var res := save_file.open("user://%s.collected" % level_name, File.READ)
		if res == OK:
			data = str2var(save_file.get_as_text())
	save_file.close()
	
	return data


static func save_user_data(data: Dictionary) ->  void:
	var data_file := File.new()
	var res := data_file.open("user://user.data", File.WRITE)
	if res == OK:
		data_file.store_string(var2str(data))
	data_file.close()


static func load_user_data() -> Dictionary:
	var data: Dictionary
	var data_file := File.new()
	if data_file.file_exists("user://user.data"):
		var res := data_file.open("user://user.data", File.READ)
		if res == OK:
			data = str2var(data_file.get_as_text())
		data_file.close()
	else:
		data = {
			"is_level_0_complete": false,
			"mouse_sensitivity": 0.5,
			"gamepad_sensitivity": 0.5,
			"audio_vol_master": 0.5,
			"audio_vol_music": 0.5,
			"audio_vol_sfx": 0.5,
			"use_snap_turn": false,
			"use_teleport": false
		}
	return data
