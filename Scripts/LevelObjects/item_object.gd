extends Interactable
class_name ItemObject

@export var item_stack: ItemStack

@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready():
	if item_stack != null:
		update_collision()

func set_item_stack(stack: ItemStack):
	item_stack = stack
	update_collision()

func update_collision():
	mesh.create_convex_collision()
	var sb: StaticBody3D = mesh.get_node("MeshInstance3D_col")
	sb.collision_layer = 32
	sb.collision_mask = 0
	
func on_interact(player: Player):
	super.on_interact(player)
	var cursor: Cursor = get_tree().get_first_node_in_group("cursor")
	if cursor.slot.is_empty():
		cursor.slot.item_stack = item_stack
		cursor.update_visuals()
		queue_free()
