extends StaticBody2D

@export var items: Array[ShopItemIcon]
@export var highlighter: Node2D
@export var item_parent: CanvasItem

var selected_item_index: int = 0
var tween: Tween
var is_shop_active: bool

func _ready() -> void:
	close_shop()
	Transition.got_sword = false
	Transition.got_bow = false

func open_shop() -> void:
	is_shop_active = true
	item_parent.visible = true
	PlayerController.current_player.can_move = false

func close_shop() -> void:
	if is_shop_active:
		PlayerController.current_player.can_move = true

	is_shop_active = false
	item_parent.visible = false

func _unhandled_input(event: InputEvent):
	if not is_shop_active: return

	if event.is_action_pressed("player_move_left") and selected_item_index > 0:
		selected_item_index -= 1
		update_selected_item()

	elif event.is_action_pressed("player_move_right") and selected_item_index < items.size() - 1:
		selected_item_index += 1
		update_selected_item()

	elif event.is_action_pressed("player_action"):
		close_shop()

		if MoneyCounter.instance.money_amount >= 30:
			Textbox.write("* Got it!")
			MoneyCounter.instance.get_money(-30)

			if selected_item_index == 0:
				Transition.got_sword = true
				PlayerController.current_player.set_item(-1)
				PlayerController.current_player.items[0] = PlayerController.current_player.get_node("Items/Sword")
				PlayerController.current_player.set_item(0)

			else:
				Transition.got_bow = true
				PlayerController.current_player.set_item(-1)
				PlayerController.current_player.items[1] = PlayerController.current_player.get_node("Items/Bow")
				PlayerController.current_player.set_item(1)

		else:
			Textbox.write("* Not enough RON...")

	elif event.is_action_pressed("player_decline"):
		close_shop()

func update_selected_item():
	if tween: tween.kill()

	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(highlighter, "global_position", items[selected_item_index].global_position, .2)

