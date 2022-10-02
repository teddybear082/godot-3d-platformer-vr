class_name Spikes
extends Spatial
# Docstring

### Private variables ###
var _damage := 100

############################
# Signal Connected Methods #
############################
func _on_player_entered(body: PhysicsBody):
	if body.get_parent().get_parent().get_parent().is_in_group("Player"):
		body.get_parent().get_parent().get_parent().take_damage(_damage)
