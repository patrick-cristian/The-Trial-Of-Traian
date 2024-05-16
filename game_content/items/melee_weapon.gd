class_name MeleeWeapon extends Item

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player = $AnimationPlayer

@export_range(1, 100, 1) var damage: int = 2
@export var screen_shake_intensity: float = 1
@export var screen_shake_duration: float = .3

var swing_direction: bool

func _input(event):
	if is_held_by_player and !is_on_cooldown and event.is_action_pressed("player_use_item") and PlayerController.current_player.can_move:
		swing()

func swing() -> void:
	start_cooldown()

	print("FUCK")

	swing_direction = !swing_direction
	animation_player.play("swing_a" if swing_direction else "swing_b")

	audio_player.pitch_scale = randf_range(.8, 1.2)
	audio_player.play()
	PlayerCamera.instance.shake(screen_shake_intensity, screen_shake_duration)

func on_body_entered(body):
	if body.has_node("Health"):
		var health: Health = body.get_node("Health")
		health.take_damage(damage, global_position)
