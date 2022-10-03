extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Function_Glide_movement_player_glide_start():
	$Glide.play() # Replace with function body.


func _on_Function_Glide_movement_player_glide_end():
	$Glide.stop() # Replace with function body.


func _on_PlayerBody_player_jumped():
	$Jump.play()# Replace with function body.




func _on_Left_Function_Grapple_movement_grapple_started():
	$Grapple.play() # Replace with function body.


func _on_Right_Function_Grapple_movement_grapple_started():
	$Grapple.play()# Replace with function body.


func _on_Function_Climb_movement_player_climb_start():
	$Climb.play()# Replace with function body.


func _on_Function_Climb_movement_player_climb_end():
	$Climb.stop() # Replace with function body.


func _on_LeftHandRadialMenu_play_menu_sound():
	if !$MenuSelect.playing:
		$MenuSelect.play() # Replace with function body.
