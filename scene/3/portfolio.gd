extends MarginContainer


@onready var blueprints = $Blueprints

var bureau = null


func set_attributes(input_: Dictionary) -> void:
	bureau = input_.bureau
	
	init_blueprints()


func init_blueprints() -> void:
	for _i in 1:
		add_blueprint()


func add_blueprint() -> void:
	var input = {}
	input.portfolio = self

	var blueprint = Global.scene.blueprint.instantiate()
	blueprints.add_child(blueprint)
	blueprint.set_attributes(input)
