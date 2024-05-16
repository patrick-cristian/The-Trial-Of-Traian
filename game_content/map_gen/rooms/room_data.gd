class_name RoomData extends Resource

@export_file("*.tscn") var scene: String
@export var rect: Rect2i
@export var doors: Array[DoorData]
@export var entrance_sides: Dictionary
@export var follow_player: bool = true
