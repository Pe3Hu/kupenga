extends MarginContainer


@onready var spots = $Spots

var space = null
var sectors = {}


func set_attributes(input_: Dictionary) -> void:
	space = input_.space
	
	init_spots()


func init_spots() -> void:
	var corners = {}
	corners.x = [0, Global.num.spot.col - 1]
	corners.y = [0, Global.num.spot.row - 1]
	
	spots.columns = Global.num.spot.col
	
	for _i in Global.num.spot.row:
		for _j in Global.num.spot.col:
			var input = {}
			input.planet = self
			input.grid = Vector2(_j, _i)
			input.sector = 0
			
			if _j != Global.num.spot.col / 2 and _i != Global.num.spot.row / 2:
				var x = sign(_j - Global.num.spot.col / 2 + 0.5) + 1
				var y = sign(_i - Global.num.spot.row / 2 + 0.5) + 1
				input.sector = x / 2 + y + 1
			
			if corners.y.has(_i) or corners.x.has(_j):
				if corners.y.has(_i) and corners.x.has(_j):
					input.type = "corner"
				else:
					input.type = "edge"
			else:
				input.type = "center"
	
			var spot = Global.scene.spot.instantiate()
			spots.add_child(spot)
			spot.set_attributes(input)
			
			if !sectors.has(input.sector):
				sectors[input.sector] = []
			
			sectors[input.sector].append(spot)
	
	init_spots_neighbor()
	init_spots_subtype()


func init_spots_neighbor() -> void:
	for spot in spots.get_children():
		for windrose in Global.dict.windrose:
			var grid = spot.grid + Global.dict.windrose[windrose]
			var neighbor = get_spot(grid)
			
			if neighbor != null:
				spot.neighbors[neighbor] = windrose
				spot.windroses[windrose] = neighbor


func init_spots_subtype() -> void:
	var grid = Vector2(ceil(Global.num.spot.row / 2), floor(Global.num.spot.col / 2))
	var core = get_spot(grid)
	core.subtype = "core"
	core.recolor("subtype")
	
	var subtypes = ["axis", "diagonal"]
	
	for subtype in subtypes:
		var key = subtype
		
		if subtype == "axis":
			key = "linear2"
		
		for direction in Global.dict.neighbor[key]:
			grid = core.grid + direction
			var spot = get_spot(grid)
			
			while spot != null:
				spot.subtype = subtype
				spot.recolor("subtype")
				grid += direction
				spot = get_spot(grid)


func check_grid(grid_: Vector2) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and Global.num.spot.row > grid_.y and Global.num.spot.col >  grid_.x


func get_spot(grid_: Vector2) -> Variant:
	if check_grid(grid_):
		var index = grid_.y * Global.num.spot.col + grid_.x
		return spots.get_child(index)
	
	return null
