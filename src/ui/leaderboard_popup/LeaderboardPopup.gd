extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal play_menu_click
var current_leaderboard = 1
var panel_children : Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	panel_children = $Panel.get_children() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Leaderboard_leaderboard_closed():
	emit_signal("play_menu_click")
	set_visible(false)


func _on_BtnNext_pressed():
	
	if current_leaderboard > 1 and current_leaderboard <= 8:
		panel_children[current_leaderboard-1].visible = false
		panel_children[current_leaderboard].visible = true
		current_leaderboard += 1
	else:
		current_leaderboard = 1
		panel_children[8].visible = false
		panel_children[current_leaderboard].visible = true
		current_leaderboard += 1
