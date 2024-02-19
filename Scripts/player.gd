extends Node3D
class_name Player

var freelook = false

var waiting = false

@export var SENSITIVITY: float = 0.003
@export var interact_distance: float = 1.5

@onready var chr: Character = $Character
@onready var head = $Character/Head
@onready var camera: Camera3D = $Character/Head/Camera3D
@onready var cursor: Cursor = %Cursor

@onready var cursor_pointer = preload("res://Resources/Images/UI/cursor-pointer.png")
@onready var cursor_hand = preload("res://Resources/Images/UI/cursor-hand.png")
@export var cursor_hand_hotspot: Vector2

var head_rotation_x: float

var left_hand_equipment: ItemStack
var right_hand_equipment: ItemStack

var moused_over_object: Interactable

func _ready():
	chr.is_player = true
	chr.fp_weapon = chr.get_node("Head").get_node("FPWeapon")
	chr.fp_weapon_update(null)
	head_rotation_x = head.rotation.x

func _physics_process(delta):
	if Input.is_action_just_pressed("lmb"):
		#if cursor.slot.is_empty():
		#	drop_item_on_ground()
		if moused_over_object != null:
			moused_over_object.on_interact(self)
	if Input.is_action_just_pressed("dbg_test"):
		#chr.anatomy.find("heart").hp = 17
		#print(chr.anatomy.find("heart").hp)
		var gm: GridMap = get_tree().get_first_node_in_group("gm_floor")
		var v = chr.get_position_on_gridmap(gm)
		gm.set_cell_item(v, -1)
	if waiting:
		if Input.is_action_just_released("wait") and TimeSystem.playing:
			TimeSystem.stop_playing()
			waiting = false
			return
	else:
		if Input.is_action_just_pressed("wait") and not TimeSystem.playing and not waiting:
			TimeSystem.begin_playing()
			waiting = true
			return
		if !%UI.character_window_visible:
			if Input.is_action_just_pressed("rmb"):
				begin_freelook()
			elif freelook and not Input.is_action_pressed("rmb"):
				end_freelook()
		if Input.is_action_pressed("move_forward"):
			chr.move_forward()
		elif Input.is_action_pressed("move_back"):
			chr.move_back()
		elif Input.is_action_pressed("strafe_left"):
			chr.strafe_left()
		elif Input.is_action_pressed("strafe_right"):
			chr.strafe_right()
		elif Input.is_action_pressed("turn_left"):
			chr.turn_left()
		elif Input.is_action_pressed("turn_right"):
			chr.turn_right()

func _input(event):
	if event is InputEventMouseMotion:
		if freelook:
			head.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89.9), deg_to_rad(89.9))
		else:
			raycast_for_interactable_object(event)

func raycast_from_mouse_position(ev: InputEvent, layer_mask: int):
	var mpos = get_viewport().get_mouse_position()
	var ray_start = camera.project_ray_origin(mpos)
	var ray_end = ray_start + camera.project_ray_normal(mpos) * interact_distance
	var world3d: World3D = get_world_3d()
	var space_state = world3d.direct_space_state
	if space_state == null:
		return
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, layer_mask)
	query.collide_with_areas = true
	return space_state.intersect_ray(query)

func raycast_for_interactable_object(ev: InputEventMouse):
	# Raycast with collision mask 32 (only 6) to pick up ground items
	var dict = raycast_from_mouse_position(ev, 32)
	if dict != null and dict.has("collider"):
		Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_ARROW, cursor_hand_hotspot)
		moused_over_object = dict["collider"].get_parent().get_parent()
	else:
		Input.set_custom_mouse_cursor(cursor_pointer, Input.CURSOR_ARROW, Vector2.ZERO)
		moused_over_object = null
	# Raycast with collision mask 1, try to throw/drop items
#	if mpos.y > get_viewport().get_visible_rect 	().size[1]/2:
#		# Bottom half, put item on ground
#		print("Drop")
#		var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, 1)
#		var dict = space_state.intersect_ray(query)
#		print(dict)
#	else:
#		# Top half, throw item
#		print("Throw")

func begin_freelook():
	freelook = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func end_freelook():
	freelook = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	head.global_rotation = chr.rotation
	head.rotation.x = head_rotation_x
	camera.rotation.x = 0
#	var head_tween = create_tween().set_trans(Tween.TRANS_QUAD)
#	var camera_tween = create_tween().set_trans(Tween.TRANS_QUAD)
#	var crd = camera.rotation
#	crd.x = 0
#	head_tween.tween_property(head, "global_rotation", chr.rotation, 0.2)
#	camera_tween.tween_property(camera, "rotation", crd, 0.2)
	
