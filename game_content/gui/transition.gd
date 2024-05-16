extends CanvasLayer

var tween: Tween
var got_bow: bool
var got_sword: bool

@onready var c: ColorRect = $ColorRect

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	c.visible = true
	c.modulate.a = 0

func do_transition(pause: bool = true) -> void:

	if pause:
		get_tree().paused = true

	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(c, "modulate:a", 1.0, .3)

	await tween.finished

	get_tree().paused = false

	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(c, "modulate:a", 0.0, .3)
