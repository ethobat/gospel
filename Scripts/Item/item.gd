extends Resource
class_name Item

@export var name: String
@export var display_name: String
@export_multiline var description: String
@export var mesh: Mesh
@export var item_slot_height: float = 0.0
@export var item_slot_rot: Vector3 = Vector3.ZERO
@export var item_slot_scale: float = 1.0
@export var provided_actions: Array[Action]
