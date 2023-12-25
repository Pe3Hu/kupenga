extends MarginContainer


@onready var blueprints = $Blueprints

var bureau = null
var kind = null


func set_attributes(input_: Dictionary) -> void:
	bureau = input_.bureau
	
	init_blueprints()


func init_blueprints() -> void:
	kind = Global.arr.layer.pick_random()
	
	for _i in 3:
		add_blueprint()


func add_blueprint() -> void:
	var input = {}
	input.portfolio = self

	var blueprint = Global.scene.blueprint.instantiate()
	blueprints.add_child(blueprint)
	blueprint.set_attributes(input)
