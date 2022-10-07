class_name LevelManager
extends Spatial
# Script to keep track of and manage level properties


### Signals ###
signal change_scene_request(target_scene_res_path)

### Enums ###

### Constants ###

### Exported  ###
export(NodePath) var _player_node_path: NodePath
#export(NodePath) var _camera_system_node_path: NodePath
export(NodePath) var _initial_checkpoint_node_path: NodePath
export(int) var _golden_time_s: int

### Public variables ###

### Private variables ###
var _time_elapsed := 0.0
var _coin_total := 0
var _coins_collected := 0
var _extras_total := 0
var _extras_collected := 0
var _death_count := 0
var _player_is_dead := false
#var _camera_system: CameraSystem
var _checkpoint_current: Checkpoint
var _time_since_last_coin_collected := 0.0
var _score: int = 0 setget _set_score
var _bonus_value: int = 1000
var _exit_entered: bool = false

### Onready variables ###
onready var _player = $player
onready var _level_name := filename.get_file().get_basename()
onready var _level_ui: LevelUI = get_node("LevelUI")
onready var _level_ui_vr = $player/FPController/RightHandController/RightHandHUD.get_scene_instance()
onready var _pause_popup: Popup = get_node("PausePopup")
onready var _level_end_screen: Popup = get_node("LevelEndScreen")
onready var _level_radial_menu = $player/FPController/LeftHandRadialMenu
onready var _level_end_screen_vr = $LevelEndScreenViewport.get_scene_instance()
onready var _level_end_screen_viewport = $LevelEndScreenViewport

onready var _projectile_container: Node = get_node("Projectiles")

onready var _audio_coin_colleceted: AudioStreamPlayer = get_node("LevelWideAudioStreams/AudioStreamCoinPickup")
onready var _audio_player_died: AudioStreamPlayer = get_node("LevelWideAudioStreams/AudioStreamPlayerDied")
onready var _audio_level_exit: AudioStreamPlayer = get_node("LevelWideAudioStreams/AudioStreamLevelExit")
onready var _audio_checkpoint: AudioStreamPlayer = get_node("LevelWideAudioStreams/AudioStreamCheckpoint")
onready var _audio_extra_collected: AudioStreamPlayer = get_node("LevelWideAudioStreams/AudioStreamExtraPickup")
############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	#_camera_system = get_node(_camera_system_node_path)
	#assert(_camera_system != null)
	#_player = get_node(_player_node_path)
	assert(_player != null)
	#_player.camera_system = _camera_system
	
	_checkpoint_current = get_node(_initial_checkpoint_node_path)
	assert(_checkpoint_current != null)
	#_player.set_transform(_checkpoint_current.get_global_transform())
	_player.global_transform.origin = _checkpoint_current.global_transform.origin
	
	_connect_signals()
	
	_count_coin_total()
	_count_extras_total()
	
	_level_ui.set_label_coin_counter(_coins_collected, _coin_total)
	_level_ui.set_label_extra_counter(_extras_collected, _extras_total)
	_level_ui.set_label_golden_time(_golden_time_s)
	
	_level_ui_vr.set_label_coin_counter(_coins_collected, _coin_total)
	_level_ui_vr.set_label_extra_counter(_extras_collected, _extras_total)
	_level_ui_vr.set_label_golden_time(_golden_time_s)
	_open_exits()

	#Set VR options from settings menu
	if UserData.use_snap_turn == true:
		_player.get_node("FPController/RightHandController/Function_Turn_movement").smooth_rotation = false
	if UserData.use_teleport == true:
		_player.get_node("FPController/LeftHandController/Function_Teleport").enabled = true
		_player.get_node("FPController/RightHandController/Function_Teleport").enabled = true
		
func _process(delta: float) -> void:
	_time_elapsed += delta
	_level_ui.set_label_time(_time_elapsed)
	_level_ui_vr.set_label_time(_time_elapsed)
	_time_since_last_coin_collected += delta


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_pause_popup.popup()


############################
#      Public Methods      #
############################



############################
# Signal Connected Methods #
############################
func _on_coin_collected(_object_name: String, value: int) -> void:
	_coins_collected += value
	_set_score(_score + (value * 20))
	if _time_since_last_coin_collected < 1:
		_audio_coin_colleceted.set_pitch_scale(min(
				_audio_coin_colleceted.pitch_scale + 0.06, 1.4
		))
	else:
		_audio_coin_colleceted.set_pitch_scale(1)
		
	_audio_coin_colleceted.play()
	_level_ui.set_label_coin_counter(_coins_collected, _coin_total)
	_level_ui_vr.set_label_coin_counter(_coins_collected, _coin_total)
	_time_since_last_coin_collected = 0


func _on_checkpoint_entered(checkpoint: Checkpoint) -> void:
	if _checkpoint_current:
		_checkpoint_current.deactivate()
	_checkpoint_current = checkpoint
	_checkpoint_current.activate()
	_audio_checkpoint.play()

func _on_projectile_spawn_requested(projectile_packed_scene: PackedScene, initial_transform: Transform, direction: Vector3, max_distance: float, speed: float, damage: int) -> void:
	var projectile_instance: Projectile = projectile_packed_scene.instance()
	projectile_instance.setup(initial_transform, direction, max_distance, speed, damage)
	_projectile_container.add_child(projectile_instance)


func _on_player_died() -> void:
	_player_is_dead = true
	_audio_player_died.play()
	_death_count += 1
	_set_score(_score - 100)
	_respawn_player()


func _on_body_exited_level_area(body: PhysicsBody) -> void:
	if body.get_parent().get_parent().get_parent().is_in_group("Player"):
		body.get_parent().get_parent().get_parent().take_damage(100)


func _on_player_entered_exit(_exit: LevelExit) -> void:
	if _exit_entered == false:
		_audio_level_exit.play()
		_exit_entered = true
		_end_level()


func _on_extra_collectable_collected(_object_name: String, value: int) -> void:
	_extras_collected += value
	_set_score(_score + (value * 500))
	if _time_since_last_coin_collected < 1:
		_audio_extra_collected.set_pitch_scale(min(
				_audio_extra_collected.pitch_scale + 0.06, 1.4
		))
	else:
		_audio_extra_collected.set_pitch_scale(1)
		
	_audio_extra_collected.play()
	_level_ui.set_label_extra_counter(_extras_collected, _extras_total)
	_level_ui_vr.set_label_extra_counter(_extras_collected, _extras_total)
	_time_since_last_coin_collected = 0


func _on_quit_level() -> void:
	$LevelArea.disconnect("body_exited", self, "_on_body_exited_level_area")
	emit_signal("change_scene_request", "res://src/ui/level_select/menu_level_select_vr.tscn")


func _on_reload_level() -> void:
	$LevelArea.disconnect("body_exited", self, "_on_body_exited_level_area")
	emit_signal("change_scene_request", filename)


############################
#      Private Methods     #
############################
func _connect_signals() -> void:
	for coin in $Coins.get_children():
		GenUtils.connect_signal_assert_ok(
				coin, "collected", 
				self, "_on_coin_collected"
		)
	
	for checkpoint in $Checkpoints.get_children():
		GenUtils.connect_signal_assert_ok(
			checkpoint, "checkpoint_entered", 
			self, "_on_checkpoint_entered"
		)
	
	for cannon in $Cannons.get_children():
		GenUtils.connect_signal_assert_ok(
			cannon, "projectile_spawn_requested", 
			self, "_on_projectile_spawn_requested"
		)
	
	for exit in $Exits.get_children():
		GenUtils.connect_signal_assert_ok(
			exit, "player_entered", 
			self, "_on_player_entered_exit"
		)
		
	for extra_collectable in $ExtraCollectable.get_children():
		GenUtils.connect_signal_assert_ok(
				extra_collectable, "collected", 
				self, "_on_extra_collectable_collected"
		)
	
	GenUtils.connect_signal_assert_ok(
			_player, "died", 
			self, "_on_player_died"
	)
	
	GenUtils.connect_signal_assert_ok(
			_pause_popup, "quit_level", 
			self, "_on_quit_level"
	)
	
	GenUtils.connect_signal_assert_ok(
			_level_end_screen, "quit_level", 
			self, "_on_quit_level"
	)
	
	GenUtils.connect_signal_assert_ok(
			_pause_popup, "reload_level", 
			self, "_on_reload_level"
	)
	
	GenUtils.connect_signal_assert_ok(
			_level_end_screen, "reload_level", 
			self, "_on_reload_level"
	)

	GenUtils.connect_signal_assert_ok(
			_level_radial_menu, "entry_selected", 
			self, "_on_radial_level_entry_selected"
	)
	
	GenUtils.connect_signal_assert_ok(
			_level_end_screen_vr, "quit_level", 
			self, "_on_quit_level"
	)
	
	GenUtils.connect_signal_assert_ok(
			_level_end_screen_vr, "reload_level", 
			self, "_on_reload_level"
	)
	
func _on_radial_level_entry_selected(entry):
	if entry == "home":
		#get_tree().quit()
		_on_quit_level()
		#emit_signal("change_scene_request", "res://src/ui/main_menu/main_menu_vr.tscn")
	if entry == "level0":
		emit_signal("change_scene_request", "res://src/levels/level_0.tscn")
	if entry == "level1":
		emit_signal("change_scene_request", "res://src/levels/level_1.tscn")
		#get_tree().change_scene("res://src/levels/level_1.tscn")
	if entry == "level2":
		emit_signal("change_scene_request", "res://src/levels/level_2.tscn")
		#get_tree().change_scene("res://src/levels/level_2.tscn")
	if entry == "level3":
		emit_signal("change_scene_request", "res://src/levels/level_3.tscn")
		#get_tree().change_scene("res://src/levels/level_3.tscn")
	if entry == "level4":
		emit_signal("change_scene_request", "res://src/levels/level_4.tscn")
		#get_tree().change_scene("res://src/levels/level_4.tscn")
	if entry == "level5":
		emit_signal("change_scene_request", "res://src/levels/level_5.tscn")
		#get_tree().change_scene("res://src/levels/level_5.tscn")
		
	if entry == "level6":
		emit_signal("change_scene_request", "res://src/levels/level_6.tscn")
		
	if entry == "level7":
		emit_signal("change_scene_request", "res://src/levels/level_7.tscn")

func _count_coin_total() -> void:
	for coin in $Coins.get_children():
		_coin_total += (coin as Collectable).get_value()


func _count_extras_total() -> void:
	_extras_total = $ExtraCollectable.get_children().size()


func _set_previously_collected_objects_materials() -> void:
	var data: Dictionary = SaveLoad.load_level_collected_collectables(_level_name)
	
	for coin_name in data["coin"]:
		var coin: Collectable = get_node("Coins/%s" % coin_name)
		coin.apply_collected_material()
	
	for extra_name in data["extra"]:
		var extra: Collectable = get_node("ExtraCollectable/%s" % extra_name)
		extra.apply_collected_material()


func _respawn_player() -> void:
	yield(get_tree().create_timer(1.5, false), "timeout")
	#_player.respawn(_checkpoint_current.get_global_transform())
	_player.respawn(_checkpoint_current.global_transform.origin + Vector3(0,1,0))
	_player_is_dead = false


func _open_exits() -> void:
	for exit in $Exits.get_children():
		(exit as LevelExit).set_active(true)
		

func _set_score(value: int) -> void:
	_score = value
	_level_ui.set_label_score(_score)
	_level_ui_vr.set_label_score(_score)


func _calculate_bonus_scores() -> Array:
	var res: Array = [0, 0, 0, 0]
	res[0] = _bonus_value if _coins_collected == _coin_total else 0
	res[1] = _bonus_value if _extras_collected == _extras_total else 0
	res[2] = _bonus_value if _death_count == 0 else 0
	res[3] = _bonus_value if _time_elapsed <= _golden_time_s else 0
	return res


func _save_score() -> void:
	SaveLoad.save_level_best(
			_level_name, _time_elapsed, _coins_collected, _coin_total,
			_extras_collected, _extras_total, _death_count, _score
	)


func _end_level() -> void:
	_level_ui.invisible()
	#_level_end_screen.popup()
	
	var bonus_scores: Array = _calculate_bonus_scores()
	var bonus_total: int = (
			bonus_scores[0] + bonus_scores[1] +
			bonus_scores[2] + bonus_scores[3]
	)
	_score += bonus_total
	
	_level_end_screen.label_player_time.set_text(
			GenUtils.format_time_minutes_seconds(_time_elapsed)
	)
	_level_end_screen.label_golden_time.set_text(
			GenUtils.format_time_minutes_seconds(_golden_time_s)
	)
	_level_end_screen.label_coin_counter.set_text(
		"%02d / %02d" % [_coins_collected, _coin_total]
	)
	_level_end_screen.label_extra_counter.set_text(
		"%d / %d" % [_extras_collected, _extras_total]
	)
	_level_end_screen.label_death_counter.set_text(str(_death_count))
	_level_end_screen.label_base_score_total.set_text(str(_score - bonus_total))
	_level_end_screen.label_all_coin_bonus.set_text(str(bonus_scores[0]))
	_level_end_screen.label_all_extra_bonus.set_text(str(bonus_scores[1]))
	_level_end_screen.label_no_death_bonus.set_text(str(bonus_scores[2]))
	_level_end_screen.label_golden_time_bonus.set_text(str(bonus_scores[3]))
	_level_end_screen.label_bonus_score_total.set_text(str(bonus_total))
	_level_end_screen.label_total_score.set_text(str(_score))
	
	
	##VR
	_level_end_screen_vr.label_player_time.set_text(
			GenUtils.format_time_minutes_seconds(_time_elapsed)
	)
	_level_end_screen_vr.label_golden_time.set_text(
			GenUtils.format_time_minutes_seconds(_golden_time_s)
	)
	_level_end_screen_vr.label_coin_counter.set_text(
		"%02d / %02d" % [_coins_collected, _coin_total]
	)
	_level_end_screen_vr.label_extra_counter.set_text(
		"%d / %d" % [_extras_collected, _extras_total]
	)
	_level_end_screen_vr.label_death_counter.set_text(str(_death_count))
	_level_end_screen_vr.label_base_score_total.set_text(str(_score - bonus_total))
	_level_end_screen_vr.label_all_coin_bonus.set_text(str(bonus_scores[0]))
	_level_end_screen_vr.label_all_extra_bonus.set_text(str(bonus_scores[1]))
	_level_end_screen_vr.label_no_death_bonus.set_text(str(bonus_scores[2]))
	_level_end_screen_vr.label_golden_time_bonus.set_text(str(bonus_scores[3]))
	_level_end_screen_vr.label_bonus_score_total.set_text(str(bonus_total))
	_level_end_screen_vr.label_total_score.set_text(str(_score))
	
	_save_score()
	
	if filename.get_file() == "level_0.tscn":
		UserData.is_level_0_complete = true
		UserData.save_to_disk()
	
	_level_end_screen_viewport.visible = true
	_player.get_node("FPController/LeftHandController/Function_pointer").enabled = true
	_player.get_node("FPController/RightHandController/Function_pointer").enabled = true
	_player.get_node("FPController/LeftHandController/Function_Teleport").enabled = false
	_player.get_node("FPController/RightHandController/Function_Teleport").enabled = false
