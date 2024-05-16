extends DirectionalCharacter

@onready var bow: ProjectileShooter = $Bow

var min_distance: float
var max_distance: float

var knockback: Vector2
var target_distance: float
var shoot_timer: float

func _ready():
	min_distance = randf_range(25, 100)
	max_distance = randf_range(125, 200)
	shoot_timer = randf_range(0, 1)

func _physics_process(delta: float):

	knockback = lerp(knockback, Vector2.ZERO, delta * 5)

	if !PlayerController.current_player: return

	bow.target = PlayerController.current_player.global_position

	var player_pos: Vector2 = PlayerController.current_player.global_position
	var direction: Vector2 = global_position.direction_to(player_pos)
	var distance: float = player_pos.distance_to(global_position)

	# back away
	if distance < min_distance:
		velocity = -direction * 150 + knockback

	# approach
	elif distance > max_distance:
		velocity = direction * 50 + knockback

	# shoot
	else:
		velocity = Vector2.ZERO
		look_at_position(player_pos)
		shoot_timer -= delta

		if shoot_timer < 0:
			shoot_timer = randf_range(.5, 2)
			bow.shoot()

	super(delta)

func on_damage_taken(_amount: int, source: Vector2):
	knockback = global_position.direction_to(source) * -100

func on_died():
	set_physics_process(false)
	animation_player.play("die")
	bow.queue_free()
	remove_from_group("enemy")
	Money.spawn(self)
	$Die.play()
	$CollisionShape2D.set_deferred("disabled", true)
