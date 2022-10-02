tool
class_name Cannon
extends StaticBody
# Docstring


### Signals ###
signal projectile_spawn_requested(projectile_packed_scene, initial_transform, direction, max_distance, speed, projectile_damage)

### Enums ###

### Constants ###

### Exported variables ###
export(float, 200) var _projectile_max_distance := 20.0 setget _set_projectile_max_distance
export(float, 0.1, 20) var _projectile_speed := 2.0
export(float, 1, 15) var _fire_rate := 10.0
export(int, 1, 100) var _projectile_damage := 100

### Public variables ###

### Private variables ###
var _is_firing := false
var _projectile_packed_scene := preload("res://src/level_elements/hazards/cannon/cannon_ball.tscn")

### Onready variables ###
onready var _projectile_spawn_point: Spatial = get_node("ProjectileSpawnPoint")
onready var _fire_timer: Timer = get_node("FireTimer")


############################
# Engine Callback Methods  #
############################

func _ready() -> void:
	if not Engine.editor_hint:
		_fire_timer.set_wait_time(_fire_rate)
		GenUtils.connect_signal_assert_ok(
				_fire_timer, "timeout", self, "_on_fire_timer_timeout"
		)
		start_firing()


############################
#      Public Methods      #
############################
func start_firing() -> void:
	_is_firing = true
	_fire_timer.start()


func stop_firing() -> void:
	_is_firing = false


############################
# Signal Connected Methods #
############################
func _on_fire_timer_timeout() -> void:
	_fire_projectile()
	if _is_firing:
		_fire_timer.start()


############################
#      Private Methods     #
############################
func _set_projectile_max_distance(val: float) -> void:
	_projectile_max_distance = val
	if Engine.editor_hint:
		var _immediate_geomtry: ImmediateGeometry = get_node("ImmediateGeometry")
		_immediate_geomtry.clear()
		_immediate_geomtry.begin(Mesh.PRIMITIVE_LINE_STRIP)
		_immediate_geomtry.add_vertex(Vector3(0, 0, 0))
		_immediate_geomtry.add_vertex(Vector3(0, 0, _projectile_max_distance))
		_immediate_geomtry.end()


func _fire_projectile() -> void:
	get_node("AudioStreamPlayer").play()
	emit_signal(
			"projectile_spawn_requested", _projectile_packed_scene,
			_projectile_spawn_point.global_transform, global_transform.basis.z, 
			_projectile_max_distance, _projectile_speed, _projectile_damage
	)
