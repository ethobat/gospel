extends Button
class_name ItemSlot

@export var clickable: bool = true

@onready var item_sprite = $ItemSprite

var item_stack: ItemStack

func _ready():
	if clickable:
		pressed.connect(_on_pressed)

func _on_pressed():
	%Cursor.on_item_slot_clicked(self)
	
func clear():
	item_stack = null

func update_visuals():
	item_sprite.texture = item_stack.item.texture
