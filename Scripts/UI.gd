extends Control

@export var player: Character

@onready var anatomy_window: Window = $AnatomyWindow
@onready var inventory_window: Window = $InventoryWindow

@onready var tree: Tree = $AnatomyWindow/AnatomyUI

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_toggle"):
		toggle_ui()

func _ready():
	var player_anatomy: Anatomy = player.anatomy
	tree.set_column_title(0, "body part")
	tree.set_column_title(1, "hp")
	populate_anatomy_tree(tree, null, player_anatomy)
	tree.set_column_custom_minimum_width(0, 200)
	toggle_ui()
	
func populate_anatomy_tree(anatomy_tree, parent_tree_item, anatomy):
	var tree_item = anatomy_tree.create_item(parent_tree_item, 0)
	tree_item.set_text(0, anatomy.name)
	tree_item.set_text(1, str(anatomy.hp))
	for child in anatomy.children:
		populate_anatomy_tree(anatomy_tree, tree_item, child)

func toggle_ui():
	anatomy_window.visible = !anatomy_window.visible
	inventory_window.visible = !inventory_window.visible
