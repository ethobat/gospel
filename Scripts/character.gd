extends Node3D
class_name Character

# copied from entity

@export var character_name: String
@export var anatomy: Anatomy
@export var inventory: Inventory

@export var move_stamina_cost: float = 1.0
@export var turn_stamina_cost: float = 0.2

# between 0 and 1
var stamina: float = 1.0
@export var base_stamina_regen: float = 0.05
var pain: float = 0.0

var windup: bool = false
var windup_action: Action
var windup_source_part: Anatomy
var windup_time: float
var fp_weapon_animation: WeaponAnimation
var fp_weapon_pos_tween: Tween
var fp_weapon_quat_tween: Tween

var moving = false
var move_original_position: Vector3
var move_destination: Vector3
var move_destination_global: Vector3
var move_passed_midway_point: bool
var move_raycast: RayCast3D
var move_reverse: bool
const MOVE_MIDWAY_POINT: float = 0.4

var turning = false
var turn_original_angle: float
var turn_destination: float

###

var progress = 0.0

var is_player = false

@onready var block_collider = $BlockCollider
@onready var raycast_forward = $BlockCollider/RaycastForward
@onready var raycast_back = $BlockCollider/RaycastBack
@onready var raycast_left = $BlockCollider/RaycastLeft
@onready var raycast_right = $BlockCollider/RaycastRight
var fp_weapon

@export var do_slide: bool = false

func _ready():
	print("Character ready")
	#TimeSystem.register_user(self)
	
func terp(x):
	return 3*pow(x, 2)-2*pow(x,3)

func get_blood_volume():
	return anatomy.get_blood_volume()
	
func get_maximum_blood_volume():
	return anatomy.get_maximum_blood_volume()

func _physics_process(delta):
	_time_process(delta)

func _time_process(delta):
	stamina = clamp(stamina+base_stamina_regen, 0, 1)
	if windup:
		continue_windup(delta)
	if moving:
		progress += delta * get_move_speed() * (-1 if move_reverse else 1)
		if progress <= 0.0:
			position = move_original_position
			moving = false
			if is_player: TimeSystem.stop_playing()
		elif not move_passed_midway_point and progress > MOVE_MIDWAY_POINT:
			do_midway_raycast()
		elif move_passed_midway_point and progress > 1.0:
			position = move_destination
			moving = false
			if is_player: TimeSystem.stop_playing()
		else:
			if do_slide:
				position = lerp(move_original_position, move_destination, terp(progress))
	elif turning:
		progress += delta * get_turn_speed()
		if progress > 1.0:
			rotation.y = turn_destination
			turning = false
			if is_player: TimeSystem.stop_playing()
		else:
			if do_slide:
				rotation.y = lerp(turn_original_angle, turn_destination, terp(progress))

func get_facing_character():
	if raycast_forward.is_colliding():
		var obj = raycast_forward.get_collider().get_parent()
		if obj is Character:
			return obj

func get_move_speed():
	return get_stat("locomotion") * 2.0

func get_turn_speed():
	return get_stat("locomotion") * 4.0
	
func try_grid_move(raycast : RayCast3D):
	if raycast.is_colliding():
		return
	var movement
	match raycast:
		raycast_forward: movement = Vector3.FORWARD
		raycast_back: movement = Vector3.BACK
		raycast_left: movement = Vector3.LEFT
		raycast_right: movement = Vector3.RIGHT
	if moving or turning: return
	if not use_stamina(move_stamina_cost):
		return
	progress = 0.0
	moving = true
	move_original_position = position
	move_destination = position + transform.basis * movement
	move_destination_global = block_collider.global_position + block_collider.transform.basis * movement
	move_passed_midway_point = false
	move_raycast = raycast
	move_reverse = false
	if is_player and not TimeSystem.playing: TimeSystem.begin_playing()

func move_and_attack_forwards(movement: Vector3):
	var destination = position + transform.basis * movement
	var destination_global = block_collider.global_position + block_collider.transform.basis * movement
	position = destination
	block_collider.global_position = destination_global

# direction: false to turn left, true to turn right
func try_grid_turn(direction):
	if moving or turning: return
	if not use_stamina(turn_stamina_cost):
		return
	progress = 0.0
	turning = true
	var delta = PI/2 * (-1 if direction else 1)
	turn_original_angle = rotation.y
	turn_destination = rotation.y + delta
	block_collider.global_rotation.y = global_rotation.y + delta
	if is_player: TimeSystem.begin_playing()
	
func turn_instant(direction):
	var delta = PI/2 * (-1 if direction else 1)
	turn_destination = rotation.y + delta
	rotation.y = turn_destination
	
# Try to drain stamina, return true if character has enough
func use_stamina(cost: float):
	if stamina >= cost:
		stamina -= cost
		return true
	return false	

func do_midway_raycast():
	move_passed_midway_point = true
	if move_raycast.is_colliding():
		move_reverse = true
	else:
		move_collider_to_destination()

func move_collider_to_destination():
	block_collider.global_position = move_destination_global

func move_forward():
	try_grid_move(raycast_forward)
	
func move_back():
	try_grid_move(raycast_back)
	
func strafe_left():
	try_grid_move(raycast_left)
	
func strafe_right():
	try_grid_move(raycast_right)
	
func turn_left():
	try_grid_turn(false)
	
func turn_right():
	try_grid_turn(true)

func get_position_on_gridmap(gridmap: GridMap):
	var vec: Vector3 = global_position# - Vector3(2,0,1)
	#vec += gridmap.global_position
	return vec as Vector3i

func fp_weapon_update(item_stack: ItemStack):
	if is_player:
		print("FP WEAPON DUPDATE!")
		if item_stack == null or item_stack.is_empty():
			fp_weapon.visible = false
		else:
			fp_weapon.visible = true
			fp_weapon.mesh = item_stack.item.mesh
			fp_weapon.position = fp_weapon_animation.neutral.pos
			fp_weapon.quaternion = fp_weapon_animation.neutral.quat

func windup_start(body_part_name: String, action_name: String):
	if windup:
		printerr("windup_start was called when windup was true")
		return
	print("Windup start")
	windup = true
	windup_source_part = anatomy.find(body_part_name)
	windup_action = windup_source_part.get_action(action_name)
	windup_time = windup_action.get_windup_time()
	if is_player:
		fp_weapon_animation = windup_action.fp_weapon_animation
		fp_weapon.position = fp_weapon_animation.neutral.pos
		fp_weapon.quaternion = fp_weapon_animation.neutral.quat
		
		TimeSystem.begin_playing()
	#var target = get_facing_character()
	
# Called in _time_process
func continue_windup(delta):
	if windup:
		windup_time -= delta
		print(windup_time)
	else:
		printerr("continue_windup was called while windup was false")

func windup_release():
	if not windup:
		printerr("windup_release was called while windup was false")
		return
	windup = false
	print("Windup release")
	if windup_time <= 0:
		if is_player:
			fp_weapon_pos_tween = fp_weapon_animation.attack.start_pos_tween(fp_weapon)
			fp_weapon_quat_tween = fp_weapon_animation.attack.start_quat_tween(fp_weapon)
			fp_weapon_pos_tween.finished.connect(func():TimeSystem.stop_playing();print("Attack finished!"))
		else:
			printerr("NYI")
	else:
		if is_player:
			TimeSystem.stop_playing()
			fp_weapon.position = fp_weapon_animation.neutral.pos
			fp_weapon.quaternion = fp_weapon_animation.neutral.quat
		else:
			printerr("NYI")

func perform_action_immediate():
	print("Doing action now!")
	if is_player:
		fp_weapon_pos_tween.kill()
		fp_weapon_quat_tween.kill()
#	var target = get_facing_character()
#	if target is Character:
#		windup_action.perform(self, windup_source_part, target)
#	else:
#		print("Miss")

func get_stat(stat_name: String):
	return anatomy.get_stat(stat_name)
