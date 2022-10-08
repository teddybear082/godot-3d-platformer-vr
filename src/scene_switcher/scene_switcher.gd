class_name SceneSwitcher
extends Node
# High level node which manages loading an transition between scenes

### Exported variables ###
export(PackedScene) var _initial_scene: PackedScene

### Private variables ###
var _current_scene: Node = null
var _loader: ResourceInteractiveLoader
var _pre_load_wait_frame_count: int


### Onready variables ###
onready var _anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var _fade_rect: ColorRect = get_node("CanvasLayer/ColorRect")
onready var _level0 = preload("res://src/levels/level_0.tscn")
onready var _level1 = preload("res://src/levels/level_1.tscn")
onready var _level2 = preload("res://src/levels/level_2.tscn")
onready var _level3 = preload("res://src/levels/level_3.tscn")
onready var _level4 = preload("res://src/levels/level_4.tscn")
onready var _level5 = preload("res://src/levels/level_5.tscn")
onready var _level6 = preload("res://src/levels/level_6.tscn")
onready var _level7 = preload("res://src/levels/level_7.tscn")

############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	_set_current_scene(_initial_scene.instance())
	OS.set_window_fullscreen(true)


func _process(_delta: float) -> void:
	var time_max := 100 # msec

	if _loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if _pre_load_wait_frame_count > 0:
		_pre_load_wait_frame_count -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max:
		var err = _loader.poll()

		if err == ERR_FILE_EOF:
			var resource = _loader.get_resource()
			_loader = null
			_set_current_scene(resource.instance())
			break
		elif err != OK:
			print("ResourceInteractiveLoader Error: " + str(_loader.poll()))
			_loader = null
			break


############################
# Signal Connected Methods #
############################
func _on_change_scene_request(scene_res_path: String) -> void:
	call_deferred("_change_scene_background", scene_res_path)


############################
#      Private Methods     #
############################

func _fade_out() -> void:
	_fade_rect.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	_anim_player.play_backwards("fade")
	yield(_anim_player, "animation_finished")
	_fade_rect.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)


func _fade_in() -> void:
	_fade_rect.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	_anim_player.play("fade")
	yield(_anim_player, "animation_finished")
	_fade_rect.set_mouse_filter(Control.MOUSE_FILTER_STOP)


func _set_current_scene(new_scene: Node) -> void:
	add_child(new_scene)
	GenUtils.connect_signal_assert_ok(
			new_scene, "change_scene_request",
			self, "_on_change_scene_request"
	)
	
	if new_scene is LevelManager:
		$AudioStreamGlobalMusic.stop()
		$AudioStreamGlobalMusic.set_stream(load("res://raw_assets/audio/MaxKoMusic/Pandemia.mp3"))
		$AudioStreamGlobalMusic.play()
	
	elif new_scene.name.matchn("*main_menu*"):
		$AudioStreamGlobalMusic.stop()
		$AudioStreamGlobalMusic.set_stream(load("res://raw_assets/audio/scottbuckley.com.au/sb_fateandfortune.mp3"))
		$AudioStreamGlobalMusic.play()
	
	_current_scene = new_scene
	if _anim_player.is_playing():
		yield(_anim_player, "animation_finished")
	_fade_out()
	
	

func _change_scene_background(new_scene_path: String) -> void:
	if new_scene_path == "":
		new_scene_path = _initial_scene.get_path()
	
	if _current_scene:
		_current_scene.disconnect("change_scene_request", self, "_on_change_scene_request")
	
	_fade_in()
	_loader = ResourceLoader.load_interactive(new_scene_path)
	assert(_loader, "ResourceLoader is null. Attemped load target path: %s" % new_scene_path)
	
	if _anim_player.is_playing():
		yield(_anim_player, "animation_finished")
	
	if _current_scene:
		_current_scene.queue_free()
	
	_pre_load_wait_frame_count = 1
	
	set_process(true)
