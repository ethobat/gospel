extends Control

@export var player: Character

@onready var character_menu: Control = $CharacterMenu

var character_window_visible: bool = false

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_toggle_character_menu"):
		toggle_character_menu()

func _ready():
	toggle_character_menu()

func toggle_character_menu():
	#anatomy_ui.visible = !anatomy_ui.visible
	#character_window_visible = anatomy_ui.visible
	character_menu.visible = !character_menu.visible
	if character_menu.visible:
		character_menu.on_display()
	
