extends MarginContainer


@onready var effect = $HBox/Impact/Effect
@onready var value = $HBox/Impact/Value
@onready var direction = $HBox/Direction
@onready var conditions = $HBox/Conditions
@onready var comparison = $HBox/Conditions/Comparison
@onready var sector = $HBox/Conditions/Sector
@onready var type = $HBox/Conditions/Type
@onready var subtype = $HBox/Conditions/Subtype


var blueprint = null


func set_attributes(input_: Dictionary) -> void:
	blueprint = input_.blueprint
	
	init_icons(input_)


func init_icons(input_: Dictionary) -> void:
	var keys = ["value", "effect", "direction"]
	
	for key in keys:
		if input_.has(key):
			var input = {}
			input.type = key
			
			if key == "value":
				input.type = "number"
			
			input.subtype = input_[key]
			var icon = get(key)
			icon.set_attributes(input)
			icon.visible = true
	
	keys = ["comparison", "sector", "type", "subtype"]
	
	for key in keys:
		if input_.has(key):
			var input = {}
			input.type = key
			input.subtype = input_[key]
			var icon = get(key)
			icon.set_attributes(input)
			icon.visible = true
