class_name BossRoomDoor extends Area2D

@export_file("*.tscn") var boss_scene: String
@export var prompt: Node2D

func _ready() -> void:
	await get_tree().process_frame
	await Textbox.write("* It is me, Traian.\n* From the Romanian History textboox.")
	await Textbox.write("* Time to fight Decebal.\n* Or, rather, his head...?")
	await Textbox.write("* But first, I have to defeat all the Dacians that lurk in this fortress.")
	await Textbox.write("* I shall purchase better gear for myself along the way, too.")

func _on_body_entered(_body):

	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")

	if enemies.size() > 0 and not Input.is_key_pressed(KEY_9):
		prompt.position.x = 643
		await Textbox.write("* Decebal's head is waiting for me on the other side of this door.")
		await Textbox.write("* I shouldn't walk out of here until I am truly ready to face him.")
		await Textbox.write("* I believe there are still %s Dacians left in this fortress. " % enemies.size())

	else:
		prompt.position.x = 389
		await Textbox.write("* No more Dacians are left here.\n*I might be ready to leave now.")

func open_door() -> void:
	await Transition.do_transition()
	get_tree().change_scene_to_file(boss_scene)
