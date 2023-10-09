extends Node3D
class_name Character

var moving = false
	
func get_move_speed():
	return 0.4
	
func get_turn_speed():
	return 0.3
	
func try_grid_move(movement):
	if moving: return
	moving = true
	var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "transform", transform.translated(transform.basis*movement), get_move_speed())
	tween.finished.connect(on_finished_moving)

# direction: false to turn left, true to turn right
func try_grid_turn(direction):
	if moving: return
	moving = true
	var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, PI/2*(-1 if direction else 1)), get_turn_speed())
	tween.finished.connect(on_finished_moving)

func on_finished_moving():
	moving = false
