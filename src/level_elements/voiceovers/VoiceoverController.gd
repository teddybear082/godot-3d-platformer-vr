extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var voiceovers = get_children()
	for voiceover in voiceovers:
		voiceover.connect("voiceover_area_entered", self, "_on_voiceover_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_voiceover_entered(body, area) -> void:
	if body.get_parent().get_parent().get_parent().is_in_group("Player"):
		if area.get_node("VoiceoverSound").playing == false:
			area.get_node("VoiceoverSound").play()
			area.set_deferred("monitoring", false)
			area.set_deferred("monitorable",false)
			
