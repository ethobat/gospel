extends Control
class_name CharacterMenu

# player character
@export var chr: Character
@export var attack_button_window: AttackButtonWindow

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

func weapon_item_stack_changed(item_stack: ItemStack):
	if item_stack == null:
		return
	if item_stack.item.item_weapon_data != null:
		print("Equipped an item with weapon data")
		var hand: Anatomy = chr.anatomy.find("right hand")
		hand.actions = item_stack.item.item_weapon_data.actions
		attack_button_window.make_attack_buttons()
		chr.fp_weapon_update(item_stack)
