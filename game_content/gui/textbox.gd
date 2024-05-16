extends CanvasLayer

@onready var timer: Timer = $Timer

@onready var label = $Panel/HBoxContainer/Label
@onready var portrait = $Panel/HBoxContainer/TextureRect/Portrait
@onready var sound: AudioStreamPlayer = $Sound

@export var default_portrait: Texture2D

signal pressed_enter
var writing: bool
var target_size: int
var tween: Tween

var punctuation: PackedStringArray = [
	",",
	".",
	"!",
	"?"
]

func _ready() -> void:
	offset.y = 500

func write(text: String, portrait_texture: Texture2D = default_portrait) -> void:

	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "offset:y", 0, .2)

	PlayerController.current_player.can_move = false

	label.visible_characters = 0
	label.text = text

	writing = true
	target_size = text.length()
	portrait.texture = portrait_texture

	while label.visible_characters < target_size:

		if punctuation.has(text[label.visible_characters]):
			timer.start(.1)

		else:
			timer.start(.01)

		label.visible_characters += 1

		if not sound.playing:
			sound.play()

		await timer.timeout

	writing = false

	await pressed_enter

	PlayerController.current_player.can_move = true

	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "offset:y", 300, .2)

func _unhandled_input(event):
	if event.is_action_pressed("player_action"):
		if writing:
			label.visible_characters = target_size
		else:
			pressed_enter.emit()
