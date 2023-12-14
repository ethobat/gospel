extends Control
class_name Cursor

@onready var slot: ItemSlot = $ItemSlot

func _ready():
	update_visuals()

func _physics_process(delta):
	position = get_global_mouse_position()

func on_item_slot_clicked(target_slot: ItemSlot):
	print("Clicky")
	if slot.is_empty() and not target_slot.is_empty():
		print("Target is full, cursor is empty")
		slot.item_stack = target_slot.item_stack
		target_slot.clear()
	elif not slot.is_empty() and target_slot.is_empty():
		print("Target is empty, cursor is full")
		target_slot.item_stack = slot.item_stack
		slot.clear()
	elif not slot.is_empty() and not target_slot.is_empty():
		print("Both are empty")
		var temp = slot.item_stack
		slot.item_stack = target_slot.item_stack
		target_slot.item_stack = temp
	update_visuals()
	target_slot.update_visuals()

func update_visuals():
	slot.update_visuals()
	slot.visible = not slot.is_empty()
