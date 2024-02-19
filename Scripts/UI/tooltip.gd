extends Control

@export_multiline var tooltip: String

func _on_mouse_entered():
	%Cursor.show_tooltip(tooltip)

func _on_mouse_exited():
	%Cursor.hide_tooltip()
