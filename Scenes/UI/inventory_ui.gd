extends Node

@onready var slot_grid = $Panel/SlotGrid
@onready var item_slot_scene = preload("res://Scenes/UI/item_slot.tscn")

@export var slots: int = 12
@export var player_inventory: bool = false

var target_inventory: Inventory

func _ready():
	if player_inventory:
		target_inventory = get_tree().get_first_node_in_group("player").get_node("Character").inventory
	update_from_inventory(target_inventory)

func update_from_inventory(inventory: Inventory):
	for i in range(slots):
		slot_grid.add_child(item_slot_scene.instantiate())
	var slot_list = slot_grid.get_children()
	for i in range(len(inventory.get_items())):
		slot_list[i].item_stack = inventory.items[i]
	for slot in slot_list:
		slot.update_visuals()
