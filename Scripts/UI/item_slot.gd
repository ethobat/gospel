extends Panel
class_name ItemSlot

@onready var amount_label = $AmountLabel
@onready var svc = $SubViewportContainer
@onready var mesh_instance = $SubViewportContainer/SubViewport/MeshInstance3D

var item_stack: ItemStack

var mouseover: bool = false
var scale_tween: Tween

func _on_mouse_entered():
	mouseover = true
	if item_stack == null or item_stack.is_empty(): return
	scale_tween = create_tween()
	scale_tween.set_trans(Tween.TRANS_QUAD)
	scale_tween.set_ease(Tween.EASE_OUT)
	var tgt = item_stack.item.item_slot_scale * 1.3
	scale_tween.tween_property(mesh_instance, "scale", Vector3(tgt, tgt, tgt), 0.5)
func _on_mouse_exited():
	mouseover = false
	if item_stack == null or item_stack.is_empty(): return
	scale_tween.kill()
	var iss = item_stack.item.item_slot_scale
	mesh_instance.scale = Vector3(iss,iss,iss)

func _physics_process(delta):
	if mouseover:
		mesh_instance.rotation.y += 1 * delta
	
func _on_gui_input(event):
	if event is InputEventMouse:
		if Input.is_action_just_pressed("lmb"):
			print("LMB")
			var cursor: Cursor = get_tree().get_first_node_in_group("cursor")
			if Input.is_key_pressed(KEY_SHIFT):
				cursor.on_item_slot_shift_clicked(self)
			else:
				cursor.on_item_slot_clicked(self)
		elif Input.is_action_just_pressed("rmb") and Input.is_key_pressed(KEY_SHIFT):
			get_tree().get_first_node_in_group("cursor").on_item_slot_shift_right_clicked(self)

func clear():
	item_stack = null

func update_visuals():
	var not_empty = not is_empty()
	svc.visible = not_empty
	amount_label.visible = not_empty
	if not_empty:
		amount_label.text = str(item_stack.count)
		mesh_instance.mesh = item_stack.item.mesh
		mesh_instance.position.y = item_stack.item.item_slot_height
		mesh_instance.rotation_degrees = item_stack.item.item_slot_rot
		mesh_instance.scale = Vector3(item_stack.item.item_slot_scale, item_stack.item.item_slot_scale, item_stack.item.item_slot_scale)
		if mesh_instance.mesh == null:
			print("Warning: Missing mesh for item %s" % item_stack.item.name)
	
func is_empty():
	return item_stack == null or item_stack.is_empty()

func disconnect_signals():
	for s in [gui_input, mouse_entered, mouse_exited]:
		for dict in s.get_connections():
			s.disconnect(dict["callable"])
