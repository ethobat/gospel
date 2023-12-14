extends Resource
class_name Inventory

@export var items: Array[ItemStack]

func get_items():
	if items == null:
		return []
	return items
