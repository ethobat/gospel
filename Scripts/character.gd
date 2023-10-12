extends Node3D
class_name Character

var moving = false
var move_original_position:Vector3
var move_destination:Vector3

var turning = false
var turn_original_angle
var turn_destination

var progress = 0.0

var is_player = false

@onready var raycast_forward = $BlockCollider/RaycastForward
@onready var raycast_back = $BlockCollider/RaycastBack
@onready var raycast_left = $BlockCollider/RaycastLeft
@onready var raycast_right = $BlockCollider/RaycastRight

func _ready():
	TimeSystem.register_user(self)

func terp(x):
	return 3*pow(x, 2)-2*pow(x,3)

func _time_process(delta):
	if moving:
		progress += delta * get_move_speed()
		if progress > 1.0:
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

func get_move_speed():
	return 2.0

func get_turn_speed():
	return 3.0
	
func try_grid_move(movement):
	if moving or turning: return
	progress = 0.0
	moving = true
	move_original_position = position
	move_destination = position + transform.basis*movement
	#var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	#tween.tween_property(self, "transform", transform.translated(transform.basis*movement), get_move_speed())
	#tween.finished.connect(on_finished_moving)
	if is_player: TimeSystem.begin_playing()

# direction: false to turn left, true to turn right
func try_grid_turn(direction):
	if moving or turning: return
	progress = 0.0
	turning = true
	turn_original_angle = rotation.y
	turn_destination = rotation.y + PI/2 * (-1 if direction else 1)
	#var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	#tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, PI/2*(-1 if direction else 1)), get_turn_speed())
	#tween.finished.connect(on_finished_moving)
	if is_player: TimeSystem.begin_playing()

func move_forward():
	if not raycast_forward.is_colliding():
		try_grid_move(Vector3.FORWARD)
	
func move_back():
	if not raycast_back.is_colliding():
		try_grid_move(Vector3.BACK)
	
func strafe_left():
	if not raycast_left.is_colliding():
		try_grid_move(Vector3.LEFT)
	
func strafe_right():
	if not raycast_right.is_colliding():
		try_grid_move(Vector3.RIGHT)
	
func turn_left():
	try_grid_turn(false)
	
func turn_right():
	try_grid_turn(true)
