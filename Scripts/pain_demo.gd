extends TextureRect

@onready var slider: Range = $HSlider
@onready var lb: Label = $Label

func _physics_process(delta):
	update_pain_noise(slider.value)

func update_pain_noise(pain_percent: float):
	lb.text = str(pain_percent)
	texture.noise.offset.z += lerp(0.1, 3.0, pain_percent)
	texture.noise.fractal_ping_pong_strength = lerp(1.0, 3.0, pain_percent)
	texture.color_ramp.offsets[1] = lerp(0.99, 0.01, pain_percent)
	texture.color_ramp.offsets[2] = lerp(0.999, 0.258, pain_percent)
