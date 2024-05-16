extends Area2D

@export var damage_amount: int = 1

var healths_to_damage: Array[Health] = []

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func _process(_delta):
	for health: Health in healths_to_damage:
		health.take_damage(damage_amount, global_position)

func on_body_entered(body: Node2D) -> void:
	if body.has_node("Health"):
		healths_to_damage.append(body.get_node("Health"))

func on_body_exited(body: Node2D) -> void:
	if body.has_node("Health"):
		healths_to_damage.erase(body.get_node("Health"))
