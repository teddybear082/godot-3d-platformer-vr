class_name GenUtils
extends Reference
# A collection of static general utility functions which may be needed by many classes
# Last updated: 2022/09/06


static func connect_signal_assert_ok(origin: Object, sig: String, target: Object, meth: String) -> void:
	var err := origin.connect(sig, target, meth)
	assert(err == OK)


static func tween_interpolate_property_vector3_assert_true_return(tween: Tween, object: Object, property: NodePath, initial_vec: Vector3, final_vec: Vector3, duration: float, trans_type := 0, ease_type := 2, delay: float = 0) -> void:
	var bool_res := tween.interpolate_property(
			object, property, initial_vec, final_vec, duration, 
			trans_type, ease_type, delay
	)
	assert(bool_res == true)


static func tween_start_assert_true_return(tween: Tween) -> void:
	var bool_res := tween.start()
	assert(bool_res == true)


static func calc_parabollic_projectile_path(point_start: Vector3, point_end: Vector3, weight_step: float) -> PoolVector3Array:
	var result: PoolVector3Array = []
	var point_mid := (
		(((point_end - point_start) * 0.5) + point_start) +
		Vector3(0, 5, 0)
	)
	
	# Calc points along Bezier curve
	var weight := 0.0
	while weight <= 1.0:
		var q0 := point_start.linear_interpolate(point_mid, weight)
		var q1 := point_mid.linear_interpolate(point_end, weight)
		var point_at_time := q0.linear_interpolate(q1, weight)
		result.append(point_at_time)
		weight += weight_step
	
	return result


static func format_time_minutes_seconds(time_seconds: float) -> String:
	var whole_seconds := int(floor(time_seconds))
	#var partial_second := time_seconds - whole_seconds
	
	var remainder_seconds: int = whole_seconds % 60
	# warning-ignore:integer_division
	var minutes: int = (whole_seconds - remainder_seconds) / 60
	
	return "%02d:%02d" % [minutes, remainder_seconds]

