extends Control
class_name CharacterMenu

func _ready():
	switch_tab(0)
	
func on_display():
	for menu in $TabMenus/Menus.get_children():
		menu.on_display()
	
func switch_tab(index: int):
	var menus = $TabMenus/Menus.get_children()
	for i in range(menus.size()):
		menus[i].visible = i == index
		menus[i].on_display()
