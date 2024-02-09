extends Control

@onready var tree: Tree = $Tree

func _ready():
	var player_anatomy: Anatomy = get_tree().get_first_node_in_group("player").get_node("Character").anatomy
	tree.set_column_title(0, "body part")
	tree.set_column_title(1, "hp")
	populate_anatomy_tree(tree, null, player_anatomy)
	tree.set_column_custom_minimum_width(0, 200)

func on_display():
	pass

func populate_anatomy_tree(anatomy_tree, parent_tree_item, anatomy):
	var tree_item = anatomy_tree.create_item(parent_tree_item, 0)
	tree_item.set_text(0, anatomy.name)
	tree_item.set_text(1, str(anatomy.hp))
	for child in anatomy.children:
		populate_anatomy_tree(anatomy_tree, tree_item, child)
