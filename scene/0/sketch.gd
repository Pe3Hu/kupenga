extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var universe = $HBox/Universe
@onready var bureau = $HBox/Bureau


func _ready() -> void:
	var input = {}
	input.sketch = self
	bureau.set_attributes(input)
	cradle.set_attributes(input)
	universe.set_attributes(input)
