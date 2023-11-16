extends Control
class_name Cursor

@onready var slot: ItemSlot = $ItemSlot

func _physics_process(delta):
	position = get_global_mouse_position()

func on_item_slot_clicked(target_slot: ItemSlot):
	if slot.is_empty() and not target_slot.is_empty():
		slot.item_stack = target_slot.item_stack
		target_slot.clear()
	if not slot.is_empty() and target_slot.is_empty():
		target_slot.item_stack = slot.item_stack
		slot.clear()
	if not slot.is_empty() and not target_slot.is_empty():
		var temp = slot.item_stack
		slot.item_stack = target_slot.item_stack
		target_slot.item_stack = temp

func visual_update():
	slot.visible = not slot.is_empty()
