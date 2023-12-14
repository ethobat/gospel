extends Button
class_name ItemSlot

@onready var item_sprite = $ItemSprite
@onready var amount_label = $AmountLabel

var item_stack: ItemStack

func _ready():
	print("Item slot READY")

func _on_pressed():
	print("Clinked")
	get_tree().get_first_node_in_group("cursor").on_item_slot_clicked(self)
	
func clear():
	item_stack = null

func update_visuals():
	var full = not is_empty()
	item_sprite.visible = full
	amount_label.visible = full
	if full:
		item_sprite.texture = item_stack.item.texture
		amount_label.text = str(item_stack.count)
	
func is_empty():
	return item_stack == null
