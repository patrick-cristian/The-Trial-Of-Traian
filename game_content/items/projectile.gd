class_name Projectile extends AnimatableBody2D

var direction: Vector2
var speed: float
var damage: int

func _ready() -> void:
	rotation = direction.angle()

func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(direction * speed * delta)

	if collision == null: return

	if collision.get_collider() is CollisionObject2D and collision.get_collider().has_node("Health"):
			var health: Health = collision.get_collider().get_node("Health")
			health.take_damage(damage, global_position)

	queue_free()
