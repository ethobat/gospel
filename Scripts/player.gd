extends Node
class_name Player

var freelook = false

@export var SENSITIVITY: float = 0.003

@onready var chr = $Character
@onready var head = $Character/Head
@onready var camera = $Character/Head/Camera3D

func _unhandled_input(event):
	if freelook and event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89.9), deg_to_rad(89.9))

func _physics_process(delta):
	if Input.is_action_just_pressed("freelook"):
		begin_freelook()
	elif freelook and not Input.is_action_pressed("freelook"):
		end_freelook()
	if Input.is_action_pressed("move_forward") and not chr.raycast_forward.is_colliding():
		chr.try_grid_move(Vector3.FORWARD)
	elif Input.is_action_pressed("move_back") and not chr.raycast_back.is_colliding():
		chr.try_grid_move(Vector3.BACK)
	elif Input.is_action_pressed("strafe_left") and not chr.raycast_left.is_colliding():
		chr.try_grid_move(Vector3.LEFT)
	elif Input.is_action_pressed("strafe_right") and not chr.raycast_right.is_colliding():
		chr.try_grid_move(Vector3.RIGHT)
	elif Input.is_action_pressed("turn_left"):
		chr.try_grid_turn(false)
	elif Input.is_action_pressed("turn_right"):
		chr.try_grid_turn(true)

func begin_freelook():
	freelook = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func end_freelook():
	freelook = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	head.global_rotation.y = chr.rotation.y
	camera.rotation.x = 0
