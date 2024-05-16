extends Sprite2D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.speed_scale = randf_range(.8, 1.2)
