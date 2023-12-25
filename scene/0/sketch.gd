extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var space = $HBox/Space
@onready var bureau = $HBox/Bureau


func _ready() -> void:
	var input = {}
	input.sketch = self
	bureau.set_attributes(input)
	cradle.set_attributes(input)
	space.set_attributes(input)
