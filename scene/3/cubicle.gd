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
	for key in Global.arr.cubicle:
		if input_.has(key):
			var input = {}
			input.type = key
			
			if key == "value":
				input.type = "number"
			
			input.subtype = input_[key]
			var icon = get(key)
			icon.set_attributes(input)
			icon.visible = true


func get_conditions() -> Dictionary:
	var conditions = {}
	
	for key in Global.arr.kind:
		var icon = get(key)
		
		if icon.visible:
			conditions[key] = icon.subtype
	
	return conditions


func get_windroses() -> Array:
	var windroses = []
	
	for index in direction.subtype:
		var windrose = Global.dict.windrose.keys()[int(index)]
		windroses.append(windrose)
	
	return windroses
