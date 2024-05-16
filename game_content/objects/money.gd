class_name Money extends Area2D

func on_body_entered(_body):

	if is_instance_valid(MoneyCounter.instance):
		MoneyCounter.instance.get_money()

	else: PlayerController.current_player.get_node("Health").cur_health += 10

	queue_free()

static func spawn(node: Node2D) -> Money:
	var packed_scene: PackedScene = load("res://game_content/objects/money.tscn")
	var money: Money = packed_scene.instantiate()

	node.get_tree().current_scene.call_deferred("add_child", money)
	money.global_position = node.global_position

	return money
