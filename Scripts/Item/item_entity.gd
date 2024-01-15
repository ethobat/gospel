extends Node3D
class_name ItemEntity

@export var item_stack: ItemStack

@onready var mesh: MeshInstance3D = $Mesh

func _ready():
	update_visuals()

func update_visuals():
	mesh.mesh = item_stack.mesh
