class_name Health extends Node

@export var max_health: int = 100
@export var damage_cooldown: float = .2
@export var damage_audio_player: AudioStreamPlayer2D
@export var bar: ColorRect

var damage_cooldown_timer: Timer
var is_on_cooldown: bool = false

signal died
signal health_changed(int)
signal damage_taken(int, Vector2)

var cur_health: int:
	set(value):
		cur_health = clampi(value, 0, max_health)
		health_changed.emit(value)

		if bar != null:
			bar.scale.x = cur_health as float / max_health

		if cur_health == 0:
			died.emit()

func _ready():
	cur_health = max_health
	damage_cooldown_timer = Timer.new()
	damage_cooldown_timer.wait_time = damage_cooldown
	damage_cooldown_timer.one_shot = true
	damage_cooldown_timer.autostart = false
	damage_cooldown_timer.timeout.connect(damage_cooldown_ended)

	add_child(damage_cooldown_timer)

func take_damage(amount: int, source: Vector2 = Vector2.ZERO) -> void:
	if is_on_cooldown or cur_health <= 0: return

	damage_taken.emit(amount, source)

	cur_health -= amount
	is_on_cooldown = true
	owner.modulate = Color.RED

	if damage_audio_player != null:
		damage_audio_player.play()

	damage_cooldown_timer.start()

func damage_cooldown_ended() -> void:
	is_on_cooldown = false
	owner.modulate = Color.WHITE
