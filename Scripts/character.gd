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

var windup: bool = false
var windup_action: Action
var windup_source_part: Anatomy
var windup_time: float

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

func _ready():
	TimeSystem.register_user(self)
	
func terp(x):
	return 3*pow(x, 2)-2*pow(x,3)

func _time_process(delta):
	if windup:
		windup_time -= delta
		if windup_time <= 0:
			windup = false
			perform_action_immediate()
			if is_player:
				TimeSystem.stop_playing()
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
			position = lerp(move_original_position, move_destination, terp(progress))
	elif turning:
		progress += delta * get_turn_speed()
		if progress > 1.0:
			rotation.y = turn_destination
			turning = false
			if is_player: TimeSystem.stop_playing()
		else:
			rotation.y = lerp(turn_original_angle, turn_destination, terp(progress))

func get_facing_character():
	if raycast_forward.is_colliding():
		var obj = raycast_forward.get_collider().get_parent()
		if obj is Character:
			return obj

func get_move_speed():
	return get_stat("locomotion") * 2.0

func get_turn_speed():
	return get_stat("locomotion") * 3.0
	
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
	if is_player: TimeSystem.begin_playing()

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

func windup_hold(body_part_name: String, action_name: String):
	if windup:
		printerr("This shouldn't happen!")
		return
	windup = true
	windup_source_part = anatomy.find(body_part_name)
	windup_action = windup_source_part.get_action(action_name)
	windup_time = windup_action.get_windup_time()
	#var target = get_facing_character()
	print("Attempting " + action_name + " with " + body_part_name)
	print("Muscle: " + str(windup_source_part.get_stat("muscle")))
	if is_player:
		TimeSystem.begin_playing()

func windup_release():
	windup = false

func perform_action_immediate():
	print("Doing action now!")
	var target = get_facing_character()
	if target is Character:
		windup_action.perform(self, windup_source_part, target)
	else:
		print("Miss")

func get_stat(stat_name: String):
	return anatomy.get_stat(stat_name)
