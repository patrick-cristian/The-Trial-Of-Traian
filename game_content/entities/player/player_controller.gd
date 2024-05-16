class_name PlayerController extends DirectionalCharacter

const SPEED: float = 300.0
static var current_player: PlayerController

var active_item_index: int
var can_move: bool = true

@export var items: Array[Item]

func _ready() -> void:
	current_player = self

	await get_tree().process_frame

	if Transition.got_sword:
		items[0] = get_node("Items/Sword")

	if Transition.got_bow:
		items[1] = get_node("Items/Bow")

	set_item(0)

func _process(delta: float) -> void:
	if not can_move: return

	items[active_item_index].player_held_process(delta)

	if Input.is_key_pressed(KEY_1): set_item(0)
	if Input.is_key_pressed(KEY_2): set_item(1)

func _physics_process(delta: float):
	if can_move:
		var input_direction: Vector2 = Input.get_vector("player_move_left", "player_move_right", "player_move_down", "player_move_up")

		velocity = input_direction * SPEED
		velocity.y = -velocity.y
		velocity *= items[active_item_index].velocity_multiplier

	else: velocity = Vector2.ZERO

	super(delta)

func set_item(index: int) -> void:
	active_item_index = index

	for i: int in items.size():
		items[i].visible = i == index
		items[i].is_held_by_player = i == index

func die():
	get_tree().change_scene_to_file("res://game_content/gui/game_over.tscn")
