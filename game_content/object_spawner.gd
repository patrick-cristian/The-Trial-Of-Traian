class_name ObjectSpawner extends Area2D

@export var max_objects: int
@export var object_scene: PackedScene
@export_range(0.0, 10.0) var spawn_interval: float

@onready var spawn_area_rect = $CollisionShape2D

var timer: Timer
var objects_spawned: int

func _ready() -> void:
	timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_object)
	timer.start()

	add_child(timer)

func spawn_object():

	var spawn_pos = Vector2(
		randf_range(spawn_area_rect.position.x, spawn_area_rect.position.x + spawn_area_rect.shape.extents.x),
		randf_range(spawn_area_rect.position.y, spawn_area_rect.position.y + spawn_area_rect.shape.extents.y))

	var object_instance = object_scene.instantiate()
	add_child(object_instance)

	object_instance.position = spawn_pos
	objects_spawned += 1

	if objects_spawned >= max_objects:
		timer.stop()
