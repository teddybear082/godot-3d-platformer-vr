class_name Player
extends KinematicBody
# Controller for the player


### Signals ###
signal died()

### Enums ###
enum COLLISION_SHAPES{STANDING, DEAD, ROLL, SPIN_JUMP}

### Constants ###

### Exported variables ###
export(float) var max_speed_fall := -30.0
export(int) var coyote_frames := 5
export(float) var jump_height := 3
export(float) var jump_time_to_peak := 0.45
export(float) var jump_time_to_return := 0.4
export(float, 1, 89) var floor_max_angle_deg := 45.0
export(float) var push: float = 1


### Public variables ###
var jump_impulse_speed: float
var gravity_acceleration_fall: float
var gravity_acceleration_jump: float

var velocity := Vector3.ZERO
var snap_vector := Vector3.ZERO
var camera_system: CameraSystem
var pushed_impulse_velocity := Vector3.ZERO
var input_movement_direction_xz := Vector3.ZERO
var can_double_jump := true
var frames_since_on_floor := 0


### Private variables ###
var _health := 100
var _health_max := 100
var _is_dead := false
var _animation_state_machine: AnimationNodeStateMachinePlayback setget ,get_animation_state_machine

var _velocity_y_rolling_average: float = 0.0


### Onready variables ###
onready var _body: Spatial = get_node("Body")
onready var _anim_tree: AnimationTree = get_node("AnimationTree")
onready var _state_machine: StateMachine = get_node("StateMachine")

onready var _bone_attach_root: BoneAttachment = get_node("Body/brain_bot_armature/Skeleton/BoneAttachmentRoot")
onready var _bone_attach_pelvis: BoneAttachment = get_node("Body/brain_bot_armature/Skeleton/BoneAttachmentPelvis")

onready var _collision_shape_standing: CollisionShape = get_node("CollisionShapeStanding")
onready var _collision_shape_dead: CollisionShape = get_node("CollisionShapeDead")
onready var _collision_shape_roll: CollisionShape = get_node("CollisionShapeRoll")
onready var _collision_shape_spin_jump: CollisionShape = get_node("CollisionShapeSpinJump")

onready var _audio_stream_pushed: AudioStreamPlayer3D = get_node("AudioStreamPushed")

############################
# Engine Callback Methods  #
############################
func _ready() -> void:
	_animation_state_machine = _anim_tree["parameters/playback"]
	_calculate_jump_parameters()


func _physics_process(delta: float) -> void:
	_velocity_y_rolling_average = 0.5 * (_velocity_y_rolling_average + velocity.y)
	
	if not is_on_floor():
		frames_since_on_floor += 1
	
	_state_machine.physics_update(delta)
	
	var collision_data: KinematicCollision = get_last_slide_collision()
	if collision_data:
		if collision_data.collider is MovingPlatform:
			var moving_platform: MovingPlatform = collision_data.collider
			rotate_y(moving_platform.angular_velocity_y * delta)


func _unhandled_input(event: InputEvent) -> void:
	_state_machine.handle_input(event)


############################
#      Public Methods      #
############################

func take_damage(value: int) -> void:
	_health = int(max(_health - value, 0))
	if (_health == 0) && (not _is_dead):
		_is_dead = true
		_state_machine.transition_to("Dead")
		emit_signal("died")


func respawn(spawn_transfrom: Transform) -> void:
	set_global_transform(spawn_transfrom)
	velocity = Vector3.ZERO
	_state_machine.return_to_initial_state()
	_is_dead = false
	_health = _health_max


func get_animation_state_machine() -> AnimationNodeStateMachinePlayback:
	return _animation_state_machine


func set_collision_shape(val: int) -> void:
	match val:
		COLLISION_SHAPES.STANDING:
			_collision_shape_standing.set_disabled(false)
			_collision_shape_dead.set_disabled(true)
			_collision_shape_roll.set_disabled(true)
			_collision_shape_spin_jump.set_disabled(true)
		
		COLLISION_SHAPES.DEAD:
			_collision_shape_dead.set_disabled(false)
			_collision_shape_standing.set_disabled(true)
			_collision_shape_roll.set_disabled(true)
			_collision_shape_spin_jump.set_disabled(true)
		
		COLLISION_SHAPES.ROLL:
			_collision_shape_roll.set_disabled(false)
			_collision_shape_dead.set_disabled(true)
			_collision_shape_standing.set_disabled(true)
			_collision_shape_spin_jump.set_disabled(true)
		
		COLLISION_SHAPES.SPIN_JUMP:
			_collision_shape_spin_jump.set_disabled(false)
			_collision_shape_roll.set_disabled(true)
			_collision_shape_dead.set_disabled(true)
			_collision_shape_standing.set_disabled(true)


############################
# Signal Connected Methods #
############################

func _on_push_area_detector_area_entered(area: Area) -> void:
	if _velocity_y_rolling_average <= -1:
		pushed_impulse_velocity = (area as PlayerPushArea).push_impulse_velocity
		_audio_stream_pushed.play()



############################
#      Private Methods     #
############################
func _calculate_jump_parameters() -> void:
	jump_impulse_speed = (2.0 * jump_height) / jump_time_to_peak
	gravity_acceleration_jump = (-2.0 * jump_height) / pow(jump_time_to_peak, 2)
	gravity_acceleration_fall = (-2.0 * jump_height) / pow(jump_time_to_return, 2)
