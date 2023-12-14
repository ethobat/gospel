extends Node

@onready var slot_grid = $SlotGrid
@onready var item_slot_scene = preload("res://Scenes/UI/item_slot.tscn")

@export var player_inventory: bool = false

var target_inventory: Inventory

func _ready():
	if player_inventory:
		target_inventory = get_tree().get_first_node_in_group("player").get_node("Character").inventory
	update_from_inventory(target_inventory)

func update_from_inventory(inventory: Inventory):
	for stack in inventory.get_items():
		var slot = item_slot_scene.instantiate()
		slot.item_stack = stack
		slot_grid.add_child(slot)
		slot.update_visuals()
		
