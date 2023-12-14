extends Control

@export var player: Character

@onready var anatomy_ui: Control = $AnatomyUI
@onready var inventory_ui: Control = $InventoryUI

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_toggle"):
		toggle_ui()

func _ready():
	toggle_ui()

func toggle_ui():
	anatomy_ui.visible = !anatomy_ui.visible
	inventory_ui.visible = !inventory_ui.visible
