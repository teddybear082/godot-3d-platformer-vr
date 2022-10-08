extends Node2D
#class_name

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
onready var label_time_deduct: Label = find_node("LabelTimeDeduct", true)
onready var btn_retry = find_node("BtnRetry", true)
onready var btn_exit = find_node("BtnExit", true)

############################
# Engine Callback Methods  #
############################


############################
#      Public Methods      #
############################


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


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	btn_retry.connect("pressed", self, "_on_btn_retry_pressed")
	btn_exit.connect("pressed", self, "_on_btn_exit_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
