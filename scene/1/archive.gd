extends MarginContainer


@onready var blueprints = $Blueprints

var architect = null


func set_attributes(input_: Dictionary) -> void:
	architect = input_.architect
