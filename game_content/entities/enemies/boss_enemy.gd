extends CharacterBody2D

@export var spawner: ObjectSpawner
@export var spike_scene: PackedScene
@export var projectile_scene: PackedScene
@export var portrait: Texture2D

const MIN_DISTANCE: float = 100.0
const MAX_DISTANCE: float = 150.0

var target_distance: float
var speed: float = 100.0

# Movement control
var is_moving: bool = true
var is_moving_left_right: bool = false
var move_direction: int = 1  # 1 for right, -1 for left

# Spike Spawn parameters
var maxspawn_radius = 75
var talking: bool = false

func _ready():
	talking = true
	target_distance = randf_range(MIN_DISTANCE, MAX_DISTANCE)

	await Textbox.write("* Gasp! Decebal's head!")
	await Textbox.write("* Ahahaha...\n* You will never defeat me, Traian!", portrait)

	talking = false

func _physics_process(delta: float):
	if !PlayerController.current_player or talking:
		return

	var player_pos: Vector2 = PlayerController.current_player.global_position
	var direction: Vector2 = global_position.direction_to(player_pos)
	var distance: float = player_pos.distance_to(global_position)

	if is_moving:
		if distance > target_distance and distance <= target_distance:
			global_position += direction * speed * delta
		else:
			# Dash
			global_position += direction * speed * delta * (distance - MIN_DISTANCE) / (target_distance - MIN_DISTANCE)
	elif is_moving_left_right:
		global_position.x += move_direction * speed * delta

	move_and_slide()

func on_died():
	spawner.queue_free()
	talking = true

	await Textbox.write("* No... NO! NOOOOO!!!!!", portrait)
	await Textbox.write("* HOW COULD THIS... HAPPEN?!", portrait)
	await Textbox.write("* And stay down!")
	await Transition.do_transition()

	get_tree().change_scene_to_file("res://game_content/gui/credits.tscn")

func change_movement():

	if talking: return

	is_moving = !is_moving
	is_moving_left_right = !is_moving
	if is_moving_left_right:
		move_direction = -1 if randf() < 0.5 else 1

func spawn_spikes():

	if talking: return

	var spikes_per_spawn = randf_range(5, 10)
	var angle = randf_range(0, 2 * PI)

	for i in range(spikes_per_spawn):
		# Random angle within a full circle
		angle += 2 * PI / spikes_per_spawn

		# Calculate position within spawn radius
		var spawn_radius = maxspawn_radius - randf_range(0, 30)
		var x = PlayerController.current_player.position.x + spawn_radius * cos(angle)
		var y = PlayerController.current_player.position.y + spawn_radius * sin(angle)
		# Instantiate spike at calculated position
		var spike = spike_scene.instantiate()
		spike.position = Vector2(x, y)
		spike.get_child(0).should_despawn = true
		get_tree().current_scene.call_deferred("add_child", spike)

func shoot():

	if talking: return

	var direction: Vector2 = global_position.direction_to(PlayerController.current_player.global_position)
	var projectile: Projectile = projectile_scene.instantiate()

	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.direction = direction
	projectile.speed = 800
	projectile.damage = 10
