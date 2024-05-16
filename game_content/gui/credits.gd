extends CanvasLayer

func _unhandled_input(event):
	if event.is_action_pressed("player_action"):
		await Transition.do_transition()
		get_tree().change_scene_to_file("res://game_content/gui/title_screen.tscn")
