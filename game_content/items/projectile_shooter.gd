class_name ProjectileShooter extends Item

@export_range(0.0, 1000.0) var projectile_speed: float = 1000.0
@export_range(1, 100, 1) var projectile_damage: int = 3
@export var collision_layer: int = 3
@export var screen_shake_intensity: float = 1
@export var screen_shake_duration: float = .3
@export_file("*.tscn") var projectile_scene_path: String

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var projectile_spawn_point: Marker2D = $Marker2D

var target: Vector2

func player_held_process(_delta: float) -> void:
	target = get_global_mouse_position()

	if is_held_by_player and !is_on_cooldown and Input.is_action_pressed("player_use_item") and PlayerController.current_player.can_move:
		shoot()

func _process(_delta: float) -> void:

	if target.x < global_position.x:

		scale.x = -1
		look_at(global_position + global_position - target)

	else:
		scale.x = 1
		look_at(target)

func stop_cooldown():
	is_on_cooldown = false

func shoot():

	start_cooldown()

	# Spawn Projectile
	var projectile: Projectile = load(projectile_scene_path).instantiate()

	projectile.global_position = projectile_spawn_point.global_position
	projectile.direction = projectile_spawn_point.global_position.direction_to(target)
	projectile.speed = projectile_speed
	projectile.damage = projectile_damage
	projectile.set_collision_mask_value(collision_layer, true)

	get_tree().current_scene.add_child(projectile)

	# Fx
	audio_player.pitch_scale = randf_range(.8, 1.2)
	audio_player.play()
	PlayerCamera.instance.shake(screen_shake_intensity, screen_shake_duration)
