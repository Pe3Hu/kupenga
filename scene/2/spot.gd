extends MarginContainer


@onready var icon = $Icon
@onready var bg = $BG

var planet = null
var grid = null
var sector = null
var type = null
var subtype = null
var windroses = {}
var neighbors = {}
var free = true


func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	grid = input_.grid
	sector = input_.sector
	type = input_.type
	subtype = "variance"
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size.spot
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)


func recolor(condition_: String):
	if Global.color.spot.has(condition_):
		var key = get(condition_)
		
		if condition_ == "sector":
			key = int(key)
		
		var style = bg.get("theme_override_styles/panel")
		style.bg_color = Global.color.spot[condition_][key]


func update_icon(condition_: String):
	var key = get(condition_)
	icon.visible = true
	
	if condition_ == "sector":
		key = int(key)
	
	var input = {}
	input.type = condition_
	input.subtype = key
	icon.set_attributes(input)


func paint(color_: String):
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Color(color_)


func check_condition(conditions_: Dictionary) -> bool:
	for condition in conditions_:
		var key = get(condition)
		
		if key != conditions_[condition]:
			return false
	
	return true


func reset() -> void:
	paint("SLATE_GRAY")
	icon.visible = false
