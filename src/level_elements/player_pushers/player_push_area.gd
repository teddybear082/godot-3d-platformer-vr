class_name PlayerPushArea
extends Area
# Docstring

export(float, 1, 100) var _push_impulse_speed: float = 5.0

var push_impulse_velocity: Vector3

func _ready() -> void:
	push_impulse_velocity = global_transform.basis.y * _push_impulse_speed

