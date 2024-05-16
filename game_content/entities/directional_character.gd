class_name DirectionalCharacter extends CharacterBody2D

enum Direction { UP, DOWN, LEFT, RIGHT}

var dir: Direction = Direction.DOWN
var is_moving: bool

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

func _physics_process(_delta: float):

	is_moving = velocity.length_squared() > 1

	if is_moving:
		sprite_2d.flip_h = velocity.x < 0
		animation_player.play("walk")
		look_in_direction(velocity)

	else:
		animation_player.play("idle")

	move_and_slide()

func look_at_position(pos: Vector2) -> void:
	look_in_direction(pos - global_position)

func look_in_direction(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 1: dir = Direction.RIGHT
		elif direction.x < -1: dir = Direction.LEFT
	elif direction.y > 1: dir = Direction.DOWN
	elif direction.y < -1: dir = Direction.UP
