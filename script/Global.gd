extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.windrose = ["N", "E", "S", "W"]
	arr.sector = [0, 1, 2, 3, 4]
	arr.type = ["corner", "edge", "center"]
	arr.subtype = ["core", "axis", "diagonal", "variance"]
	arr.comparison = ["less", "equal", "more"]
	arr.cubicle = ["value", "effect", "direction", "sector", "type", "subtype", "comparison"]
	arr.kind = ["sector", "type", "subtype", "comparison"]
	arr.layer = ["sector", "type", "subtype"]


func init_num() -> void:
	num.index = {}
	
	num.spot = {}
	num.spot.col = 11
	num.spot.row = num.spot.col


func init_dict() -> void:
	init_neighbor()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	
	init_windrose()


func init_windrose() -> void:
	dict.windrose = {}
	
	for _i in arr.windrose.size():
		for _j in 2:
			var windrose = arr.windrose[_i]
			var direction = dict.neighbor.linear2[_i]
			
			if _j == 1:
				var index = (_i + 1) % arr.windrose.size()
				windrose += arr.windrose[index]
				direction = dict.neighbor.diagonal[_i]
			
			if windrose == "ES":
				windrose = "SE"
			
			if windrose == "WN":
				windrose = "NW"
			
			dict.windrose[windrose] = direction
	
	init_direction()


func init_direction() -> void:
	dict.direction = {}
	var step = 2
	var n = dict.windrose.keys().size()
	
	for _i in n:
		for _j in 2:
			var indexs = []
			
			for _l in _j + 1:
				var index = (_i + _l * step) % n
				indexs.append(index)
				
			
			indexs.sort()
			var direction = ""
			
			for index in indexs:
				direction += str(index)
			
			var weight = pow(4, 2-_j)
			dict.direction[direction] = weight
	
	dict.direction["0246"] = 1
	dict.direction["1357"] = 1


func init_blank() -> void:
	dict.blank = {}
	dict.blank.title = {}
	
	var path = "res://asset/json/poupou_blank.json"
	var array = load_data(path)
	
	for blank in array:
		var data = {}
		
		for key in blank:
			if key != "title":
				data[key] = blank[key]
		
		dict.blank.title[blank.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.architect = load("res://scene/1/architect.tscn")
	
	scene.field = load("res://scene/2/field.tscn")
	scene.spot = load("res://scene/2/spot.tscn")
	
	scene.portfolio = load("res://scene/3/portfolio.tscn")
	scene.blueprint = load("res://scene/3/blueprint.tscn")
	scene.cubicle = load("res://scene/3/cubicle.tscn")
	


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.number = Vector2(5, 32)
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.aspect = Vector2(32, 32)
	vec.size.box = Vector2(100, 100)
	vec.size.bar = Vector2(120, 12)
	
	vec.size.spot = Vector2(64, 64)
	
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.spot = {}
	color.spot.type = {}
	color.spot.type.corner = Color.from_hsv(0 / h, 0.6, 0.7)
	color.spot.type.edge = Color.from_hsv(60 / h, 0.6, 0.7)
	color.spot.type.center = Color.from_hsv(270 / h, 0.6, 0.7)
	
	color.spot.subtype = {}
	color.spot.subtype.core = Color.from_hsv(300 / h, 0.9, 0.7)
	color.spot.subtype.axis = Color.from_hsv(210 / h, 0.9, 0.7)
	color.spot.subtype.diagonal = Color.from_hsv(30 / h, 0.9, 0.7)
	color.spot.subtype.variance = Color.from_hsv(120 / h, 0.9, 0.7)
	
	color.spot.sector = {}
	
	for _i in 5:
		var _h = _i / 5.0
		color.spot.sector[_i] = Color.from_hsv(_h, 0.7, 0.8)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
