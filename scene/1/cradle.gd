extends MarginContainer


@onready var architects = $Architects

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_architects()


func init_architects() -> void:
	for _i in 1:
		var input = {}
		input.cradle = self
	
		var architect = Global.scene.architect.instantiate()
		architects.add_child(architect)
		architect.set_attributes(input)
