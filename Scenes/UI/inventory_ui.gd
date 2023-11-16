extends Node

@onready var slot_grid = $SlotGrid
@onready var item_slot_scene = preload("res://Scenes/UI/item_slot.tscn")

func update_from_inventory(inventory: Inventory):
	for stack in inventory.items:
		var slot = item_slot_scene.instantiate()
		slot.item_stack = stack
		slot.update_visuals()
		slot_grid.add_child(slot)
