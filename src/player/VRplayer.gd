extends Spatial



### Signals ###
signal died()


### Private variables ###
var _health := 100
var _health_max := 100
var _is_dead := false
# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name().to_lower() == "android":
		get_viewport().msaa = Viewport.MSAA_DISABLED
		$FPController/Configuration.set_render_target_size_multiplier(1.5)
	
	else:
		get_viewport().msaa = Viewport.MSAA_8X


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
	$FPController/PlayerBody.velocity = Vector3(0,0,0)
	global_transform.origin = spawn_transfrom
	$FPController.global_transform.origin = spawn_transfrom
	$FPController/PlayerBody.velocity = Vector3(0,0,0)
	_is_dead = false
	_health = _health_max
