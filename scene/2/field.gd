extends MarginContainer


@onready var spots = $Spots

var space = null
var sectors = {}
var current = {}
var selection = {}


func set_attributes(input_: Dictionary) -> void:
	space = input_.space
	
	init_spots()
	current.layer = null
	#change_current_layer(0)
	prepare_selection()
	var cubicle = space.sketch.bureau.portfolios.get_child(0).blueprints.get_child(0).cubicles.get_child(1)
	#find_all_suitable_spots(cubicle)


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
	#core.recolor("subtype")
	
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
				#spot.recolor("subtype")
				grid += direction
				spot = get_spot(grid)


func check_grid(grid_: Vector2) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and Global.num.spot.row > grid_.y and Global.num.spot.col >  grid_.x


func get_spot(grid_: Vector2) -> Variant:
	if check_grid(grid_):
		var index = grid_.y * Global.num.spot.col + grid_.x
		return spots.get_child(index)
	
	return null


func change_current_layer(shift_: int) -> void:
	if current.layer == null:
		current.layer = Global.arr.layer.front()
	
	var index = Global.arr.layer.find(current.layer)
	index = (index + shift_ + Global.arr.layer.size()) % Global.arr.layer.size()
	current.layer = Global.arr.layer[index]
	
	for spot in spots.get_children():
		spot.update_icon(current.layer)
		spot.recolor(current.layer)


func find_all_suitable_spots(cubicle_: MarginContainer) -> void:
	reset_spots()
	var conditions = cubicle_.get_conditions()
	var targets = []
	var suitables = {}
	suitables.intersection = []
	var windroses = {}
	windroses.origin = cubicle_.get_windroses()
	windroses.reflected = []
	
	for windrose in windroses.origin:
		var index = Global.dict.windrose.keys().find(windrose)
		index = (index + Global.dict.windrose.keys().size() / 2) % Global.dict.windrose.keys().size()
		var reflection = Global.dict.windrose.keys()[index]
		windroses.reflected.append(reflection)
		suitables[reflection] = []
	
	if conditions.keys().is_empty(): 
		suitables.append_array(spots.get_children())
	else:
		for spot in spots.get_children():
			if spot.check_condition(conditions):
				targets.append(spot)
				spot.paint("Red")
		
		for target in targets:
			for windrose in windroses.reflected:
				if target.windroses.has(windrose):
					var spot = target.windroses[windrose]
					suitables[windrose].append(spot)
					
					if !suitables.intersection.has(spot):
						suitables.intersection.append(spot)
	
		for _i in range(suitables.intersection.size()-1,-1,-1):
			var spot = suitables.intersection[_i]
			var flag = true
			
			for windrose in windroses.reflected:
				flag = flag and suitables[windrose].has(spot)
				
				if !flag:
					break
			
			if !flag:
				suitables.intersection.erase(spot)
		
		for suitable in suitables.intersection:
			if selection.has(suitable):
				suitable.paint("Green")


func reset_spots() -> void:
	for spot in spots.get_children():
		spot.reset()


func prepare_selection() -> void:
	selection = []
	
	for sector in sectors:
		var options = []
		
		for spot in sectors[sector]:
			if spot.free:
				options.append(spot)
		
		for _i in 2:
			var spot = options.pick_random()
			selection.append(spot)
			spot.paint("blue")
			options.erase(spot)
