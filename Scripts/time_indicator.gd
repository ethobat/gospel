extends Control

@onready var play = $Play
@onready var pause = $Pause

func _ready():
	TimeSystem.register_user(self)

func _on_time_play():
	play.show()
	pause.hide()
	
func _on_time_pause():
	play.hide()
	pause.show()
