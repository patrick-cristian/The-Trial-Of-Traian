class_name DoorData extends Resource

@export var tile_cell: Vector2i
@export var side: Side
@export var id: int
@export_range(0, 1) var spawn_chance: float = 0.5

func _init(tile_cell_: Vector2i = Vector2i.ZERO, side_: Side = SIDE_BOTTOM, spawn_chance_: float = .5, id_: int = 0) -> void:
	tile_cell = tile_cell_
	side = side_
	spawn_chance = spawn_chance_
	id = id_
