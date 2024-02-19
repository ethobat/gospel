extends Node3D

@onready var mesh = $MeshInstance3D
@onready var template_index_label: Label = $TemplateIndexLabel
@onready var templates: Node3D = $Templates

@export var debug: bool = false

var phase: int = 0

var template_count: int
var cur_template_index = 0
var template: AttackAnimationTemplate

func _ready():
	template_count = 0
	for child in templates.get_children():
		template_count += 1
		child.visible = false
	load_from_template()

func load_from_template():
	template = templates.get_children()[cur_template_index]
	$MeshInstance3D.visible = true
	$MeshInstance3D.mesh = template.mesh
	if pos_tween != null: pos_tween.kill()
	if quat_tween != null: quat_tween.kill()
	template.weapon_animation.neutral.pos = template.get_node("Neutral").position
	template.weapon_animation.neutral.quat = template.get_node("Neutral").quaternion
	template.weapon_animation.windup.pos = template.get_node("Windup").position
	template.weapon_animation.windup.quat = template.get_node("Windup").quaternion
	template.weapon_animation.attack.pos = template.get_node("Attack").position
	template.weapon_animation.attack.quat = template.get_node("Attack").quaternion
	template.visible = false
	mesh.position = template.weapon_animation.neutral.pos
	mesh.quaternion = template.weapon_animation.neutral.quat
	if debug:
		play_pose(template.weapon_animation.neutral)

var pos_tween: Tween
var quat_tween: Tween
	
func _physics_process(delta):
	if Input.is_action_just_pressed("dbg_test"):
		var path = "Resources/WeaponAnimations/" + template.name + ".tres"
		ResourceSaver.save(template.weapon_animation, path)
		print("Saved to " + path)
	if Input.is_action_just_pressed("strafe_right"):
		cur_template_index += 1
		print(cur_template_index)
		update_template_index()
	if Input.is_action_just_pressed("strafe_left"):
		cur_template_index -= 1
		print(cur_template_index)
		update_template_index()
		
	
func update_template_index():
	print(cur_template_index)
	if cur_template_index == template_count:
		cur_template_index = 0
	elif cur_template_index == -1:
		cur_template_index = template_count - 1
	print(cur_template_index)
	template_index_label.text = str(cur_template_index)
	load_from_template()
	
func play_pose(wp: WeaponPose):
	pos_tween = wp.start_pos_tween(mesh)
	quat_tween = wp.start_quat_tween(mesh)
	pos_tween.finished.connect(on_neutral if wp==template.weapon_animation.neutral else (on_windup if wp==template.weapon_animation.windup else on_attack))
	
func on_neutral():
	print("Neutral")
	play_pose(template.weapon_animation.windup)
	
func on_windup():
	print("Windup")
	play_pose(template.weapon_animation.attack)
	
func on_attack():
	print("Attack")
	play_pose(template.weapon_animation.neutral)
