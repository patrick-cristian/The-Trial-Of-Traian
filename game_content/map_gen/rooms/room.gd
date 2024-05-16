@tool class_name Room extends Node2D

@export var tilemap: TileMap
@export var doors: Array[Door]
@export var data: RoomData
@export var update_data: bool:
	set(value):
		if not value: return

		data.scene = self.scene_file_path
		data.rect = tilemap.get_used_rect()

		var door_nodes: Array[Node] = get_tree().get_nodes_in_group("door")

		doors = []
		for i: int in door_nodes.size():
			doors.append(door_nodes[i])
			doors[i].id = i
			doors[i].room = self

		data.doors = []
		data.entrance_sides.clear()

		for door: Door in doors:
			var pos: Vector2i = tilemap.local_to_map(tilemap.to_local(door.global_position))
			data.doors.append(DoorData.new(pos, door.side, door.spawn_chance, door.id))

			if not data.entrance_sides.has(door.side):
				data.entrance_sides[door.side] = [ door.id ]

			else:
				data.entrance_sides[door.side].append(door.id)


func enable_room() -> void:
	visible = true
	set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)

	var map_limits: Rect2i = tilemap.get_used_rect()

	map_limits.position *= tilemap.rendering_quadrant_size
	map_limits.size *= tilemap.rendering_quadrant_size
	map_limits.position += Vector2i(tilemap.global_position)

	PlayerCamera.instance.global_position = map_limits.get_center()
	PlayerCamera.instance.follow_player = data.follow_player


func disable_room() -> void:
	visible = false
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
