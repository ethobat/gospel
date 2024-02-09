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

var head_rotation_x: float

var left_hand_equipment: ItemStack
var right_hand_equipment: ItemStack

func _ready():
	chr.is_player = true
	head_rotation_x = head.rotation.x

func _input(event):
	if freelook and event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89.9), deg_to_rad(89.9))

func _physics_process(delta):
	#if Input.is_action_just_pressed("lmb"):
	#	try_interact()
		
	if Input.is_action_just_pressed("dbg_test"):
		#chr.anatomy.find("heart").hp = 17
		#print(chr.anatomy.find("heart").hp)
		var gm: GridMap = get_tree().get_first_node_in_group("gm_floor")
		var v = chr.get_position_on_gridmap(gm)
		print(v)
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
		if not TimeSystem.playing:
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

func try_interact(ev: InputEvent):
	if !(ev is InputEventMouse and ev.button_mask == 1):
		return
	var mpos = get_viewport().get_mouse_position()
	var ray_start = camera.project_ray_origin(mpos)
	var ray_end = ray_start + camera.project_ray_normal(mpos) * interact_distance
	var world3d: World3D = get_world_3d()
	var space_state = world3d.direct_space_state
	if space_state == null:
		return
	if cursor.slot.is_empty():
		# Raycast with collision mask 32 (only 6) to pick up ground items
		var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, 32)
		query.collide_with_areas = true
		var dict = space_state.intersect_ray(query)
		if dict.has("collider"):
			dict["collider"].get_parent().get_parent().on_interact(self)
	else:
		# Raycast with collision mask 1, try to throw/drop items
		if mpos.y > get_viewport().get_visible_rect().size[1]/2:
			# Bottom half, put item on ground
			print("Drop")
			var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, 1)
			var dict = space_state.intersect_ray(query)
			print(dict)
		else:
			# Top half, throw item
			print("Throw")

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
	
