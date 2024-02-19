extends Resource
class_name WeaponPose

@export var pos: Vector3
@export var quat: Quaternion
@export var time: float = 1.0
@export var pos_ease: Tween.EaseType
@export var pos_trans_type: Tween.TransitionType
@export var rot_ease: Tween.EaseType
@export var rot_trans_type: Tween.TransitionType

func start_pos_tween(object: Node3D) -> Tween:
	var tween = object.create_tween()
	tween.set_trans(pos_trans_type)
	tween.set_ease(pos_ease)
	tween.tween_property(object, "position", pos, time)
	return tween

func start_quat_tween(object: Node3D) -> Tween:
	var tween = object.create_tween()
	tween.set_trans(rot_trans_type)
	tween.set_ease(rot_ease)
	tween.tween_property(object, "quaternion", quat, time)
	return tween
