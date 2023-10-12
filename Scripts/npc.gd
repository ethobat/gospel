extends Node3D

func _ready():
	TimeSystem.register_user(self)
	
func _time_process(delta):
	global_rotation.y += delta * 10
