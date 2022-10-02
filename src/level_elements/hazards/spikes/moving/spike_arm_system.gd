#class_name
extends Spikes
# Docstring


### Exported variables ###
export(int) var _layer_1_ang_vel: int = 40
export(int, 0, 4) var _layer_1_arm_count: int = 1
export(int) var _layer_2_ang_vel: int = 40
export(int, 0, 4) var _layer_2_arm_count: int = 1
export(int) var _layer_3_ang_vel: int = 40
export(int, 0, 4) var _layer_3_arm_count: int = 1

### Public variables ###

### Private variables ###

### Onready variables ###
onready var _arm_scene_res: PackedScene = preload(
		"res://src/level_elements/hazards/spikes/moving/spike_arm.tscn"
)

onready var _layer_1: Spatial = get_node("Layer1")
onready var _layer_2: Spatial = get_node("Layer2")
onready var _layer_3: Spatial = get_node("Layer3")

onready var _angular_velocities: PoolRealArray = [
	deg2rad(_layer_1_ang_vel),
	deg2rad(_layer_2_ang_vel),
	deg2rad(_layer_3_ang_vel),
]


############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	$PerimiterMarker.queue_free()
	
	var layer_arm_seperation: float
	var spike_arm_instance: Area
	
	if _layer_1_arm_count > 0:
		layer_arm_seperation = float(2*PI) / _layer_1_arm_count
		var current_arm_rotation: float = 0
		for _i in range(_layer_1_arm_count):
			spike_arm_instance = _arm_scene_res.instance()
			_layer_1.add_child(spike_arm_instance)
			spike_arm_instance.rotate_y(current_arm_rotation)
			current_arm_rotation += layer_arm_seperation
			
			GenUtils.connect_signal_assert_ok(
					spike_arm_instance, "body_entered",
					self, "_on_player_entered"
			)
	
	if _layer_2_arm_count > 0:
		layer_arm_seperation = float(2*PI) / _layer_2_arm_count
		var current_arm_rotation: float = 0
		for _i in range(_layer_2_arm_count):
			spike_arm_instance = _arm_scene_res.instance()
			_layer_2.add_child(spike_arm_instance)
			spike_arm_instance.rotate_y(current_arm_rotation)
			current_arm_rotation += layer_arm_seperation
			
			GenUtils.connect_signal_assert_ok(
					spike_arm_instance, "body_entered",
					self, "_on_player_entered"
			)
	
	if _layer_3_arm_count > 0:
		layer_arm_seperation = float(2*PI) / _layer_3_arm_count
		var current_arm_rotation: float = 0
		for _i in range(_layer_3_arm_count):
			spike_arm_instance = _arm_scene_res.instance()
			_layer_3.add_child(spike_arm_instance)
			spike_arm_instance.rotate_y(current_arm_rotation)
			current_arm_rotation += layer_arm_seperation
			
			GenUtils.connect_signal_assert_ok(
					spike_arm_instance, "body_entered",
					self, "_on_player_entered"
			)


func _physics_process(delta: float) -> void:
	_layer_1.rotate_y(_angular_velocities[0] * delta)
	_layer_2.rotate_y(_angular_velocities[1] * delta)
	_layer_3.rotate_y(_angular_velocities[2] * delta)
