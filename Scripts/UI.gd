extends Control

@onready var anatomy_window = $AnatomyWindow
@onready var inventory_window = $InventoryWindow

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_toggle"):
		toggle_ui()

func toggle_ui():
	anatomy_window.visible = !anatomy_window.visible
	inventory_window.visible = !inventory_window.visible
