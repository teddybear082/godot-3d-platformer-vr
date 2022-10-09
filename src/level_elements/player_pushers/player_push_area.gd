class_name PlayerPushArea
extends Area
# Docstring

export(float, 1, 100) var _push_impulse_speed: float = 5.0

var push_impulse_velocity: Vector3

func _ready() -> void:
	push_impulse_velocity = global_transform.basis.y * _push_impulse_speed



func _on_PlayerPushArea_body_entered(body):
	if get_parent().get_parent().get_parent().is_in_group("Player"):
		body.get_parent().request_jump() # Replace with function body.
