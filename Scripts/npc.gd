extends Node3D

@onready var chr: Character = $Character

var rng = RandomNumberGenerator.new()

func _ready():
	TimeSystem.register_user(self)
	chr.turn_left()
	
func _physics_process(delta):
	#global_rotation.y += delta * 10
	#ai_random()
	ai_fwd()

func ai_fwd():
	chr.move_forward()

func ai_random():
	var mt = rng.randi_range(0,5)
	match mt:
		0: chr.turn_left()
		1: chr.move_forward()
		2: chr.turn_right()
		3: chr.strafe_left()
		4: chr.move_back()
		5: chr.strafe_right()
