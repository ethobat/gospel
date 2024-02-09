extends Node3D

@onready var mesh = $MeshInstance3D

@export var anim: WeaponAnimation

var phase: int = 0

func _ready():
	var base = get_node("2")
	anim.neutral.pos = base.get_node("Neutral").position
	anim.neutral.quat = base.get_node("Neutral").quaternion
	anim.windup.pos = base.get_node("Windup").position
	anim.windup.quat = base.get_node("Windup").quaternion
	anim.attack.pos = base.get_node("Attack").position
	anim.attack.quat = base.get_node("Attack").quaternion
	get_node("1").visible = false
	get_node("2").visible = false
	mesh.position = anim.neutral.pos
	mesh.quaternion = anim.neutral.quat
	play_pose(anim.neutral)

var pos_tween: Tween
var quat_tween: Tween
	
func play_pose(wp: WeaponPose):
	pos_tween = wp.start_pos_tween(mesh)
	quat_tween = wp.start_quat_tween(mesh)
	pos_tween.finished.connect(on_neutral if wp==anim.neutral else (on_windup if wp==anim.windup else on_attack))
	
func on_neutral():
	print("Neutral")
	play_pose(anim.windup)
	
func on_windup():
	print("Windup")
	play_pose(anim.attack)
	
func on_attack():
	print("Attack")
	play_pose(anim.neutral)
