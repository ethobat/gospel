extends TextureRect

@onready var label = $Label

@export var write_speed_mult: float = 1.0
@export var period_pause: float = 20.0

var writing : bool
var msg : String
var write_counter : float
var write_counter_threshold : float
var visible_characters : int

func _ready():
	show_message("The ass saw the angel of the Lord. 4229 4231. Go to heaven and snatch a tooth from the mouth of God. 4241 4243. The perceived value of profanity is based on a fundamentally flawed rubric.")
		
func _process(delta):
	if writing:
		write_counter += delta * write_speed_mult
		if write_counter > write_counter_threshold:
			write_counter -= write_counter_threshold
			visible_characters += 1
			label.text = msg.substr(0, visible_characters)
			#label.visible_characters = visible_characters
			write_counter_threshold = (period_pause if msg[visible_characters-1] == "." else 1.0)
			if visible_characters == msg.length():
				writing = false

func show_message(msg : String):
	self.visible = true
	self.msg = msg
	writing = true
	write_counter = 0.0
	write_counter_threshold = 1.0
	visible_characters = 0
	label.text = msg
