extends Node
class_name Player

var freelook = false

var waiting = false

@export var SENSITIVITY: float = 0.003

@onready var chr = $Character
@onready var head = $Character/Head
@onready var camera = $Character/Head/Camera3D

func _ready():
	chr.is_player = true

func _input(event):
	if freelook and event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89.9), deg_to_rad(89.9))

func _physics_process(delta):
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
		if Input.is_action_just_pressed("freelook"):
			begin_freelook()
		elif freelook and not Input.is_action_pressed("freelook"):
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

func begin_freelook():
	freelook = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func end_freelook():
	freelook = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	head.global_rotation = chr.rotation
	camera.rotation.x = 0
#	var head_tween = create_tween().set_trans(Tween.TRANS_QUAD)
#	var camera_tween = create_tween().set_trans(Tween.TRANS_QUAD)
#	var crd = camera.rotation
#	crd.x = 0
#	head_tween.tween_property(head, "global_rotation", chr.rotation, 0.2)
#	camera_tween.tween_property(camera, "rotation", crd, 0.2)
	
