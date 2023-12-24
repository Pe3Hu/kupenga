extends MarginContainer


@onready var archive = $HBox/Archive

var cradle = null


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	var input = {}
	input.architect = self
	archive.set_attributes(input)
