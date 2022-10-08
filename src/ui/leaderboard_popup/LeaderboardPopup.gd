extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal play_menu_click
var current_leaderboard = null
var current_leaderboard_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_leaderboard = load("res://src/ui/leaderboard_popup/level_0.tscn").instance()
	$Panel.add_child(current_leaderboard)
	current_leaderboard_num = 0
	current_leaderboard.connect("leaderboard_closed", self, "_on_Leaderboard_leaderboard_closed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Leaderboard_leaderboard_closed():
	emit_signal("play_menu_click")
	set_visible(false)


func _on_BtnNext_pressed():
	$Panel.remove_child(current_leaderboard)
	current_leaderboard.queue_free()
	current_leaderboard_num+=1
	if current_leaderboard_num > 7:
		current_leaderboard_num = 0
	current_leaderboard = load("res://src/ui/leaderboard_popup/level_" + str(current_leaderboard_num) + ".tscn").instance()
	$Panel.add_child(current_leaderboard)
	current_leaderboard.connect("leaderboard_closed", self, "_on_Leaderboard_leaderboard_closed")
