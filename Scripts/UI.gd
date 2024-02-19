extends Control

@export var player_chr: Character

@onready var character_menu: Control = $CharacterMenu
@onready var blood_meter: Range = $BottomBar/StatDisplay/Meters/BloodMeter
@onready var stamina_meter: Range = $BottomBar/StatDisplay/Meters/StaminaMeter

var character_window_visible: bool = false

var pain_texture: NoiseTexture2D

@onready var lb: Label = $BottomBar/PainDisplayPanel/PainDisplay/Label

func _ready():
	pain_texture = $BottomBar/PainDisplayPanel/PainDisplay.texture
	toggle_character_menu()
	var tween = create_tween()
	tween.tween_property(player_chr, "pain", 1, 5)
	tween.finished.connect(func():player_chr.pain=0)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_toggle_character_menu"):
		toggle_character_menu()
	blood_meter.value = 1
	stamina_meter.value = player_chr.stamina
	update_pain_noise(player_chr.pain / player_chr.get_stat("discipline"))
	
func update_pain_noise(pain_percent: float):
	lb.text = str(pain_percent)
	pain_texture.noise.offset.z += lerp(0.1, 3.0, pain_percent)
	#pain_noise.fractal_lacunarity = lerp(2.0, 4.0, pain_percent)
	pain_texture.noise.fractal_ping_pong_strength = lerp(1.0, 3.0, pain_percent)
	pain_texture.color_ramp.offsets[1] = lerp(0.99, 0.01, pain_percent)
	pain_texture.color_ramp.offsets[2] = lerp(0.999, 0.258, pain_percent)

func toggle_character_menu():
	#anatomy_ui.visible = !anatomy_ui.visible
	#character_window_visible = anatomy_ui.visible
	character_menu.visible = !character_menu.visible
	if character_menu.visible:
		character_menu.on_display()	

func _on_blood_meter_mouse_entered():
	%Cursor.show_tooltip("Blood volume: "+str(player_chr.get_blood_volume())+"ccs / "+str(player_chr.get_maximum_blood_volume())+" ccs\nTotal blood volume in body.\nLow blood limits CIRCULATION, which in turn limits all other stats.\nYou pass out below ~40%.")

func _on_blood_meter_mouse_exited():
	%Cursor.hide_tooltip()

func _on_stamina_meter_mouse_entered():
	%Cursor.show_tooltip("Stamina: "+str(player_chr.stamina)+"\nEnergy currently available for actions.\nStrenuous activities like combat require a lot of stamina.\nStamina regeneration is limited by CIRCULATION.")

func _on_stamina_meter_mouse_exited():
	%Cursor.hide_tooltip()


func _on_pain_display_mouse_entered():
	%Cursor.show_tooltip("Visual metric for pain. Deep blue is the color of a clear and calm mind.\nOne can only endure so much pain before passing out due to pain shock.\nThe higher the DISCIPLINE stat, the more pain one can endure.")

func _on_pain_display_mouse_exited():
	%Cursor.hide_tooltip()
