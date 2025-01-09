extends Area3D

@export_multiline var message: String

var triggered: bool = false

func _on_body_entered(body: Node3D):
	print(body.get_parent().get_parent().name + " entered!")
	triggered = true
	get_tree().get_first_node_in_group("prophet").show_message(message)

func _on_body_exited(body):
	print("Exit " + body.get_parent().get_parent().name)
