extends VBoxContainer
class_name RightClickMenu

var menu_item = preload("res://Scenes/UI/right_click_menu_item.tscn")

func add_menu_item(label: String, callable: Callable):
	var mi: Button = menu_item.instantiate()
	mi.get_node("Label").text = label
	mi.button_down.connect(callable)
