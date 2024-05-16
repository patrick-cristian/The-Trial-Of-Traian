class_name Footsteps extends AudioStreamPlayer2D

@export var entity: DirectionalCharacter

const TIME_BETWEEN_STEPS: float = .3
const PITCH_RANGE: float = .7

var last_step_time: float

func _process(_delta):
	if entity.is_moving and Time.get_unix_time_from_system() - last_step_time > TIME_BETWEEN_STEPS:
		last_step_time = Time.get_unix_time_from_system()
		pitch_scale = 1.0 + randf_range(-PITCH_RANGE, PITCH_RANGE)
		play()
