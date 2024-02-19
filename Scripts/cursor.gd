extends Control
class_name Cursor

@onready var slot: ItemSlot = $ItemSlot
@onready var tooltip_panel: Panel = $TooltipPanel
@onready var tooltip: Label = $Tooltip

@export var tooltip_margin: Vector2

var displaying_tooltip: bool = false

# workaround for weird behavior where two clicks are detected at one for some reason
var clicked_this_frame: bool = false

func _ready():
	clicked_this_frame = false
	hide_tooltip()
	update_visuals()

func _physics_process(delta):
	clicked_this_frame = false
	position = get_global_mouse_position()

func on_item_slot_clicked(target_slot: ItemSlot):
	if clicked_this_frame: return
	clicked_this_frame = true
	if slot.is_empty() and not target_slot.is_empty():
		#print("Target is full, cursor is empty")
		slot.item_stack = target_slot.item_stack
		target_slot.clear()
	elif not slot.is_empty() and target_slot.is_empty():
		#print("Target is empty, cursor is full")
		target_slot.item_stack = slot.item_stack
		slot.clear()
	elif not slot.is_empty() and not target_slot.is_empty():
		#print("Both are empty")
		if not target_slot.item_stack.try_combine(slot.item_stack):
			var temp = slot.item_stack
			slot.item_stack = target_slot.item_stack
			target_slot.item_stack = temp
	update_visuals()
	target_slot.update_visuals()

func on_item_slot_shift_clicked(target_slot: ItemSlot):
	if clicked_this_frame: return
	clicked_this_frame = true
	#print("Shift clicked")

func on_item_slot_shift_right_clicked(target_slot: ItemSlot):
	if clicked_this_frame: return
	clicked_this_frame = true
	#print("src")
	if slot.is_empty() and not target_slot.is_empty():
		slot.item_stack = target_slot.item_stack.take(1)
	elif not slot.is_empty() and target_slot.is_empty():
		target_slot.item_stack = slot.item_stack.take(1)
	elif not slot.is_empty() and not target_slot.is_empty() and slot.item_stack.is_combinable(target_slot.item_stack):
		slot.item_stack.combine(target_slot.item_stack.take(1))
	update_visuals()
	target_slot.update_visuals()

func update_visuals():
	slot.update_visuals()
	slot.visible = not slot.is_empty()

func show_tooltip(text: String):
	# only update tooltip if it's not already being displayed
	if not tooltip.visible:
		tooltip_panel.visible = true
		tooltip.visible = true
		tooltip.text = text

func resize_tooltip_panel():
	if tooltip_panel == null: return
	tooltip_panel.size = tooltip.size + tooltip_margin
	tooltip_panel.position = Vector2(-tooltip_margin.x/2,tooltip_margin.y/2-tooltip_panel.size.y)

func hide_tooltip():
	tooltip_panel.visible = false
	tooltip.visible = false
