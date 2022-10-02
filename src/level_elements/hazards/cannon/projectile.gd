class_name Projectile
extends Area
# Docstring

### Private variables ###
var _initial_position: Vector3
var _direction: Vector3
var _max_distance_squared: float
var _speed: float
var _damage: int


############################
# Engine Callback Methods  #
############################
func _physics_process(delta: float) -> void:
	global_transform.origin += _direction * _speed * delta
	var distance_traveled_squared := _initial_position.distance_squared_to(global_transform.origin)
	if distance_traveled_squared > _max_distance_squared:
		_destroy()


############################
#      Public Methods      #
############################
func setup(initial_transform: Transform, direction: Vector3, max_distance: float, speed: float, damage: int) -> void:
	set_global_transform(initial_transform)
	_initial_position = initial_transform.origin
	_direction = direction.normalized()
	_max_distance_squared = pow(max_distance, 2)
	_speed = speed
	_damage = damage


############################
# Signal Connected Methods #
############################
func _on_body_entered(body: PhysicsBody):
	if body is Player:
		(body as Player).take_damage(_damage)
	_destroy()

############################
#      Private Methods     #
############################
func _destroy() -> void:
	queue_free()
