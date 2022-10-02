#class_name
extends Popup
# Docstring


### Signals ###
signal quit_level()
signal reload_level()

### Enums ###

### Constants ###

### Exported variables ###

### Public variables ###

### Private variables ###

### Onready variables ###
onready var label_player_time: Label = find_node("LabelPlayerTime", true)
onready var label_golden_time: Label = find_node("LabelGoldenTime", true)
onready var label_coin_counter: Label = find_node("LabelCoinCounter", true)
onready var label_extra_counter: Label = find_node("LabelExtraCounter", true)
onready var label_death_counter: Label = find_node("LabelDeathCounter", true)
onready var label_base_score_total: Label = find_node("LabelBaseScoreTotal", true)
onready var label_all_coin_bonus: Label = find_node("LabelAllCoinBonus", true)
onready var label_all_extra_bonus: Label = find_node("LabelAllExtraBonus", true)
onready var label_no_death_bonus: Label = find_node("LabelNoDeathBonus", true)
onready var label_golden_time_bonus: Label = find_node("LabelGoldenTimeBonus", true)
onready var label_bonus_score_total: Label = find_node("LabelBonusScoreTotal", true)
onready var label_total_score: Label = find_node("LabelTotalScore", true)


############################
# Engine Callback Methods  #
############################


############################
#      Public Methods      #
############################

func popup(bounds: Rect2 = Rect2( 0, 0, 0, 0 )) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	.popup(bounds)
	get_tree().set_pause(true)


############################
# Signal Connected Methods #
############################

func _on_btn_exit_pressed():
	get_tree().set_pause(false)
	emit_signal("quit_level")


func _on_btn_retry_pressed():
	get_tree().set_pause(false)
	emit_signal("reload_level")



############################
#      Private Methods     #
############################
