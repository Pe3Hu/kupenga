extends MarginContainer


@onready var bg = $BG

var planet = null
var grid = null
var sector = null
var type = null
var subtype = null
var windroses = {}
var neighbors = {}


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
	recolor("sector")


func recolor(condition_: String):
	var key = get(condition_)
	
	if condition_ == "sector":
		key = int(key)
	
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.spot[condition_][key]
