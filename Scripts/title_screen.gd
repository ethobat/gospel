extends Node3D

@export var camera_pivot_speed: float = 0.2
@export var title_bob_speed: float = 1.0
@export var title_bob_magnitude: float = 1.0

@onready var camera_pivot: Node3D = $CameraPivot
@onready var title: Sprite3D = $CameraPivot/Camera3D/Title

var title_bob_progress: float = 0.0
var title_original_y: float

func _ready():
	title_original_y = title.position.y

func _physics_process(delta):
	camera_pivot.rotation.y += camera_pivot_speed * delta
	title_bob_progress += title_bob_speed * delta
	if title_bob_progress > 1:
		title_bob_progress -= 1
	title.position.y = title_original_y + sin(PI * 2 * title_bob_progress) * title_bob_magnitude
