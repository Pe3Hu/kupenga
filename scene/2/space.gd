extends MarginContainer


@onready var fields = $Fields

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_fields()


func init_fields() -> void:
	for _i in 1:
		var input = {}
		input.space = self
	
		var field = Global.scene.field.instantiate()
		fields.add_child(field)
		field.set_attributes(input)
