extends TextureRect

@onready var label = $Label

@export var fade_in_mult: float = 2.0
@export var write_in_mult: float = 1.0
@export var period_pause: float = 20.0
@export var hold_time: float = 20.0
@export var write_out_mult: float = 1.0
@export var fade_out_mult: float = 0.01

var phase: Phase
var msg: String
var timer: float
var timer_threshold: float
var modulate_timer: float = 0.0
enum Phase { INVISIBLE, FADE_IN, WRITE_IN, HOLD, WRITE_OUT, FADE_OUT }

func _ready():
	self.self_modulate.a = 0.0
	label.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	phase = Phase.INVISIBLE
	label.visible_characters = 0
	#show_message("The ass saw the angel of the LORD. 4229 4231. Go to heaven and snatch a tooth from the mouth of God. 4241 4243. The perceived value of profanity is based on a fundamentally flawed rubric.")

func _process(delta):
	if phase != Phase.INVISIBLE:
		modulate_timer += delta
		self.self_modulate.r = 0.7+0.3*sin(modulate_timer*50)
		self.self_modulate.g = 0.7+0.3*cos(modulate_timer*16+200)
		self.self_modulate.b = 0.7+0.3*sin(modulate_timer*9+400)
	if phase == Phase.FADE_IN:
		timer += delta * fade_in_mult
		self.self_modulate.a = min(timer, 1.0)
		if timer >= 1.5:
			phase = Phase.WRITE_IN
			timer = 0.0
	elif phase == Phase.WRITE_IN:
		timer += delta * write_in_mult
		if timer > timer_threshold:
			timer -= timer_threshold
			label.visible_characters += 1
			#label.text = msg.substr(0, visible_characters)
			#label.visible_characters = visible_characters
			timer_threshold = (period_pause if msg[label.visible_characters-1] == "." else 1.0)
			if label.visible_characters == msg.length():
				phase = Phase.HOLD
				timer = 0.0
	elif phase == Phase.HOLD:
		timer += delta
		if timer >= hold_time:
			phase = Phase.WRITE_OUT
			label.visible_characters = msg.length()
			timer = 0.0
	elif phase == Phase.WRITE_OUT:
		timer += delta * write_out_mult
		if timer > 1.0:
			timer -= 1.0
			label.visible_characters -= 1
			if label.visible_characters == 0:
				phase = Phase.FADE_OUT
				timer = 0.0
	elif phase == Phase.FADE_OUT:
		timer += delta * fade_out_mult
		self.modulate.a = max(1.0-timer, 0.0)
		if timer >= 1.0:
			phase = Phase.INVISIBLE
			timer = 0.0

func show_message(new_msg : String):
	if phase != Phase.INVISIBLE:
		return
	msg = new_msg
	phase = Phase.FADE_IN
	timer = 0.0
	timer_threshold = 1.0
	label.visible_characters = 0
	label.text = msg
