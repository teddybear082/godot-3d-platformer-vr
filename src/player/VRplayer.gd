extends Spatial



### Signals ###
signal died()


### Private variables ###
var _health := 100
var _health_max := 100
var _is_dead := false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(value: int) -> void:
	_health = int(max(_health - value, 0))
	if (_health == 0) && (not _is_dead):
		_is_dead = true
		emit_signal("died")



func respawn(spawn_transfrom: Vector3) -> void:
	#set_global_transform(spawn_transfrom)
	#velocity = Vector3.ZERO
	global_transform.origin = spawn_transfrom
	$FPController.global_transform.origin = spawn_transfrom
	_is_dead = false
	_health = _health_max
