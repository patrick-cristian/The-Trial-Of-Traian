class_name PlayerCamera extends Camera2D

var noise: FastNoiseLite
var intensity: float
var time: float
var tween: Tween
var follow_player: bool = false

static var instance: PlayerCamera

func _ready():
	instance = self

	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 1
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE

func _physics_process(_delta: float) -> void:
	if follow_player:
		global_position = PlayerController.current_player.global_position

func _process(delta: float):

	time += delta * 5

	offset.x = noise.get_noise_2d(time, 0) * intensity * 10
	offset.y = noise.get_noise_2d(0, time) * intensity * 10

func shake(intensity_: float, duration: float) -> void:
	intensity = intensity_

	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "intensity", 0, duration)
