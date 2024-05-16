extends Area2D

signal prompt_pressed

var is_nearby: bool

@onready var label = $"."

func _ready():
	label.visible = false

func on_body_entered(_body: Node2D) -> void:
	is_nearby = true
	label.visible = true

func on_body_exited(_body: Node2D) -> void:
	is_nearby = false
	label.visible = false

func _unhandled_input(event):
	if is_nearby and PlayerController.current_player.can_move and event.is_action_pressed("player_action"):
		prompt_pressed.emit()
		label.visible = PlayerController.current_player.can_move
		get_viewport().set_input_as_handled()
