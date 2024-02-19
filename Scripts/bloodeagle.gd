extends Node3D
class_name BloodEagle

@onready var anim_run: Animation = preload("res://Resources/3D/animations/run.res")

@onready var chr: Character = $Character
@onready var animator: AnimationPlayer = $Character/bloodeagle/BloodEagleAnimated/AnimationPlayer

@onready var atktime_armada: float = 1.0

var rng = RandomNumberGenerator.new()

func _ready():
	animator.animation_set_next("bloodeagle/idle", "bloodeagle/idle")
	animator.animation_set_next("bloodeagle/turnleft", "bloodeagle/idle")
	animator.animation_set_next("bloodeagle/turnright", "bloodeagle/idle")
	animator.animation_set_next("bloodeagle/armada", "bloodeagle/idle")
	chr.turn_left()
	
func _physics_process(delta):
	ai_fwd()

func ai_fwd():
	if chr.moving or chr.turning:
		pass
	if not Input.is_action_just_pressed("dbg_test"):
		return
	else:
		#armada_left()
		#return
		if rng.randi_range(0,0) == 0:
			turn_left()
		else:
			turn_right()



func turn_left():
	animator.play("bloodeagle/turnleft")
	#animator.animation_set_next("bloodeagle/idle", "bloodeagle/turnleft")
	animator.speed_scale = chr.get_turn_speed()

func turn_right():
	animator.play("bloodeagle/turnright")
	#animator.animation_set_next("bloodeagle/idle", "bloodeagle/turnright")
	animator.speed_scale = chr.get_turn_speed()
	
func armada_left():
	animator.play("bloodeagle/armada")
	animator.speed_scale = atktime_armada

func ai_random():
	var mt = rng.randi_range(0,5)
	match mt:
		0:
			turn_left()
		1:
			chr.move_forward()
		2:
			turn_right()
		3:
			chr.strafe_left()
		4:
			chr.move_back()
		5:
			chr.strafe_right()

func _on_animation_changed(old_name: String, new_name: String):
	if old_name == "bloodeagle/idle":
		return
	if old_name == "bloodeagle/armada":
		chr.move_and_attack_forwards(Vector3(1,0,1))
		return
	if old_name == "bloodeagle/turnleft":
		chr.turn_instant(false)
	if old_name == "bloodeagle/turnright":
		chr.turn_instant(true)
	#animator.current_animation = "bloodeagle/idle"
