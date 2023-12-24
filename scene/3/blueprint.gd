extends MarginContainer


@onready var cubicles = $Cubicles

var portfolio = null


func set_attributes(input_: Dictionary) -> void:
	portfolio = input_.portfolio
	
	roll_cubicles()


func roll_cubicles() -> void:
	var input = {}
	input.blueprint = self
	input.effect = "wound"
	input.value = 4
	
	var cubicle = Global.scene.cubicle.instantiate()
	cubicles.add_child(cubicle)
	cubicle.set_attributes(input)
	
	input.effect = "wound"
	input.value = 9
	input.direction = Global.get_random_key(Global.dict.direction)
	var kind = Global.arr.kind.pick_random()
	var key = Global.arr[kind].pick_random()
	input[kind] = key
	
	cubicle = Global.scene.cubicle.instantiate()
	cubicles.add_child(cubicle)
	cubicle.set_attributes(input)
