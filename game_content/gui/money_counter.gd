class_name MoneyCounter extends Label

@export var audio: AudioStreamPlayer

static var instance: MoneyCounter

var money_amount: int
var tween: Tween

func _ready():
	instance = self

func get_money(amount: int = 1):
	money_amount += amount
	PlayerController.current_player.get_node("Health").cur_health += 5

	audio.pitch_scale = randf_range(.8, 1.2)
	audio.play()

	text = str(money_amount) + " ron"
	scale = Vector2.ONE * 1.5

	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, .2)
