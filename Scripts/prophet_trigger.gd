extends Area3D

@export var message: String

var triggered: bool = false

func _on_body_entered(body: Node3D):
	print(body.get_parent().get_parent().name + " entered!")
	triggered = true
	%Prophet.show_message(message)

func _on_body_exited(body):
	print("Exit " + body.get_parent().get_parent().name)
