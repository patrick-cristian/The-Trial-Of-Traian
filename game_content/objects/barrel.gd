extends StaticBody2D

@onready var animation_player = $AnimationPlayer

func die() -> void:
	animation_player.play("break")

func spawn_money() -> void:
	Money.spawn(self)
