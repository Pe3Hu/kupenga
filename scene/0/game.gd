extends Node


@onready var sketch = $Sketch
var n = 0

func _ready() -> void:
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	#Global.rng.randomize()
	#var random = Global.rng.randi_range(0, 1)
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					sketch.space.fields.get_child(0).change_current_layer(-1)
			KEY_D:
				if event.is_pressed() && !event.is_echo():
					sketch.space.fields.get_child(0).change_current_layer(1)
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					n = (n + 1) % 3
					var cubicle = sketch.bureau.portfolios.get_child(0).blueprints.get_child(n).cubicles.get_child(1)
					sketch.space.fields.get_child(0).find_all_suitable_spots(cubicle)


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
