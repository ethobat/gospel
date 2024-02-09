extends Panel

@export var chr: Character
@export var stat_name: String
@export var tooltip: String

@onready var stat_name_label: Label = $StatNameLabel
@onready var value_label: Label = $ValueLabel

func _ready():
	stat_name_label.text = stat_name
	#update_value_label()

func update_value_label():
	value_label.text = chr.get_stat(stat_name)



func _on_mouse_entered():
	%Cursor.show_tooltip(tooltip)

func _on_mouse_exited():
	%Cursor.hide_tooltip()
