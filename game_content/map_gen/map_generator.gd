extends Node2D

@export var room_datas: Array[RoomData]
@export var start_room: RoomData
@export var max_rooms: int = 10
@export var tile_size: int = 16

var used_rects: Array[Rect2i]
var used_doors: PackedStringArray = []

var rooms_spawned_counter: int
var rooms_spawned_percentage: float

var rooms: Array[Room]

func _ready() -> void:

	generate_room({"room_data" : start_room})

	await get_tree().process_frame

	rooms[0].enable_room()

func generate_room(params: Dictionary) -> void:

	# counter
	rooms_spawned_counter += 1
	rooms_spawned_percentage = (rooms_spawned_counter as float) / max_rooms

	# spawn
	var room_data: RoomData = params["room_data"]
	var room_scene: PackedScene = load(room_data.scene)
	var room_position: Vector2i = params.get("position", Vector2i.ZERO)
	var room: Room = room_scene.instantiate()

	add_child(room)

	room.global_position = room_position * room.tilemap.rendering_quadrant_size
	room.disable_room()

	rooms.append(room)

	# occupy rect
	var rect: Rect2i = room.tilemap.get_used_rect()
	rect.position += room_position

	used_rects.append(rect)

	# wait
	await get_tree().process_frame

	room.doors.shuffle()

	for door: Door in room.doors:

		# this is the spawn door, leave it alone
		if door.id == params.get("entrance_door_id", -1):
			door.linked_door = params["exit_door"]
			params["exit_door"].linked_door = door
			continue

		# maximum doors reaches
		if rooms_spawned_counter >= max_rooms:
			door.queue_free()
			continue

		# random spawn chance
		if randf() > door.spawn_chance + 1 - rooms_spawned_percentage:
			door.queue_free()
			continue

		# check rooms
		var door_exit_side: Side = opposite_side(door.side)
		var next_spawn_position_in_tiles: Vector2i = Vector2i(door.global_position / room.tilemap.rendering_quadrant_size) + side_offset_in_tiles(door.side)
		var room_params: Array[Dictionary] = []

		for s_room_data: RoomData in room_datas:
			var potential_room_spawn_rect: Rect2i = Rect2i(
				room_data.rect.position + next_spawn_position_in_tiles,
				room_data.rect.size)

			if s_room_data.entrance_sides.has(door_exit_side) and rect_free(potential_room_spawn_rect):

				room_params.append({
					"room_data": s_room_data,
					"position" : next_spawn_position_in_tiles,
					"entrance_door_id" : s_room_data.entrance_sides[door_exit_side].pick_random(),
					"exit_door" : door
				})

		# no rooms
		if room_params.size() == 0:
			door.queue_free()
			continue

		generate_room(room_params.pick_random())


func rect_free(rect: Rect2i) -> bool:
	for r: Rect2i in used_rects:
		if r.intersects(rect):
			return false

	return true

func opposite_side(side: Side) -> Side:
	match side:
		SIDE_BOTTOM: return SIDE_TOP
		SIDE_TOP: return SIDE_BOTTOM
		SIDE_LEFT: return SIDE_RIGHT
		SIDE_RIGHT: return SIDE_LEFT
	return SIDE_BOTTOM

func side_offset_in_tiles(side: Side) -> Vector2i:
	match side:
		SIDE_BOTTOM: return Vector2i.DOWN * 100
		SIDE_TOP: return Vector2i.UP * 100
		SIDE_LEFT: return Vector2i.LEFT * 100
		SIDE_RIGHT: return Vector2i.RIGHT * 100
	return Vector2i.ZERO
