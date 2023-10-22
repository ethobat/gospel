extends GridContainer

@export var player: Entity

func _ready():
	make_attack_buttons()

func make_attack_buttons():
	var scene = load("res://Scenes/UI/attack_button.tscn")
	for node in get_children():
		node.queue_free()
	make_attack_button(scene, "left hand", "punch")
	make_attack_button(scene, "right hand", "punch")

func make_attack_button(scene, body_part_name, attack_name):
	var button = scene.instantiate()
	add_child(button)
	button.body_part_name = body_part_name
	button.attack_name = attack_name
	button.initialize()
	button.button_down.connect(func(): player.perform_attack(button.body_part_name, button.attack_name))
	
