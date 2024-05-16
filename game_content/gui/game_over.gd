extends CanvasLayer

@export var buttons: Array[Panel]
@export var move_audio: AudioStreamPlayer
@export var select_audio: AudioStreamPlayer
@export_file("*.tscn") var dungeon_scene: String

var current_button_index: int
var tween: Tween
var loading: bool

func _ready():
	update_buttons()

func _unhandled_input(event):

	if loading: return

	if current_button_index > 0 and event.is_action_pressed("player_move_up"):
		current_button_index -= 1
		move_audio.play()
		update_buttons()

	elif current_button_index < buttons.size() - 1 and event.is_action_pressed("player_move_down"):
		current_button_index += 1
		move_audio.play()
		update_buttons()

	elif event.is_action_pressed("player_action"):

		loading = true
		select_audio.play()

		if tween: tween.kill()

		tween = create_tween().set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", Vector2.ONE * 10, .5)

		await Transition.do_transition(false)

		match current_button_index:
			0: get_tree().change_scene_to_file(dungeon_scene)
			1: get_tree().quit()


func update_buttons() -> void:
	if tween: tween.kill()

	tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	for button: Panel in buttons:
		var is_selected: bool = button == buttons[current_button_index]

		tween.tween_property(button, "modulate:a", 1.0 if is_selected else 0.5, .25)
		tween.tween_property(button, "scale", Vector2.ONE if is_selected else Vector2.ONE * .7, .5)
