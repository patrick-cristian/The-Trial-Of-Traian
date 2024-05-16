class_name ShopItemIcon extends Sprite2D

@export var item_icon: Sprite2D
@export var item_name_label: Label

func set_item(item_texture: Texture2D, item_name: String) -> void:
	item_name_label.text = item_name
	item_icon.texture = item_texture
