class_name LevelUI
extends CanvasLayer
# Docstring


### Signals ###

### Enums ###

### Constants ###

### Exported variables ###

### Public variables ###

### Private variables ###

### Onready variables ###
onready var _label_coin_counter: Label = find_node("CoinCounter", true)
onready var _label_extra_counter: Label = find_node("ExtraCounter", true)
onready var _label_time: Label = find_node("TimeLabel", true)
onready var _label_golden_time: Label = find_node("GoldenTimeLabel", true)
onready var _label_score: Label = find_node("ScoreLabel", true)
onready var _label_fps: Label = find_node("LabelFPS", true)


############################
# Engine Callback Methods  #
############################
func _process(_delta: float) -> void:
	_label_fps.set_text(str(Performance.get_monitor(Performance.TIME_FPS)))


############################
#      Public Methods      #
############################
func set_label_coin_counter(coin_count: int, coin_target: int) -> void:
	_label_coin_counter.set_text("%02d  of  %02d" % [coin_count, coin_target])


func set_label_extra_counter(extra_count: int, extra_total: int) -> void:
	_label_extra_counter.set_text("%d  of  %d" % [extra_count, extra_total])


func set_label_time(time_seconds: float) -> void:
	var string := GenUtils.format_time_minutes_seconds(time_seconds)
	_label_time.set_text(string)


func set_label_golden_time(time_seconds: float) -> void:
	var string := GenUtils.format_time_minutes_seconds(time_seconds)
	_label_golden_time.set_text(string)


func set_label_score(score: int) -> void:
	_label_score.set_text("%04d" % score)


func invisible() -> void:
	$Control.set_visible(false)
