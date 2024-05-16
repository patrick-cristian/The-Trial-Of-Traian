class_name Door extends Area2D

@export var side: Side
@export var id: int
@export_range(0.0, 1.0) var spawn_chance: float = 0.5
@export var room: Room

@export var linked_door: Door
@onready var exit_point = $ExitPoint

func on_body_entered(body) -> void:

	if body == PlayerController.current_player and PlayerController.current_player.can_move:

		await Transition.do_transition()

		room.disable_room()
		linked_door.room.enable_room()

		PlayerController.current_player.global_position = linked_door.exit_point.global_position
