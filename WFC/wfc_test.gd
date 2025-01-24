extends Node3D

class_name WaveFunctionCollapse3D

class Tile:
	var id: int
	var weight: float
	var possible_neighbors = {
		"up": [],
		"down": [],
		"north": [],
		"south": [],
		"east": [],
		"west": []
	}
	
	func _init(tile_id: int, tile_weight: float = 1.0):
		id = tile_id
		weight = tile_weight

class Cell:
	var possible_states: Array
	var collapsed: bool
	var position: Vector3
	
	func _init(states: Array, pos: Vector3):
		possible_states = states.duplicate()
		collapsed = false
		position = pos
	
	func entropy() -> float:
		return possible_states.size()

var grid_size: Vector3
var tiles: Dictionary = {}
var cells: Array = []
var rng = RandomNumberGenerator.new()

func _init(size: Vector3):
	grid_size = size
	rng.randomize()

func add_tile(id: int, weight: float = 1.0) -> Tile:
	var tile = Tile.new(id, weight)
	tiles[id] = tile
	return tile

func add_neighbor_rules(tile_id: int, rules: Dictionary):
	if tiles.has(tile_id):
		for direction in rules:
			if tiles[tile_id].possible_neighbors.has(direction):
				tiles[tile_id].possible_neighbors[direction] = rules[direction]

func initialize_grid():
	cells.clear()
	var all_tile_ids = tiles.keys()
	
	for z in range(grid_size.z):
		var plane = []
		for y in range(grid_size.y):
			var row = []
			for x in range(grid_size.x):
				var cell = Cell.new(all_tile_ids, Vector3(x, y, z))
				row.append(cell)
			plane.append(row)
		cells.append(plane)

func get_min_entropy_cell() -> Cell:
	var min_entropy = INF
	var candidates = []
	
	for z in range(grid_size.z):
		for y in range(grid_size.y):
			for x in range(grid_size.x):
				var cell = cells[z][y][x]
				if cell.collapsed:
					continue
				var entropy = cell.entropy()
				if entropy < min_entropy:
					min_entropy = entropy
					candidates = [cell]
				elif entropy == min_entropy:
					candidates.append(cell)
	
	if candidates.size() > 0:
		return candidates[rng.randi() % candidates.size()]
	return null

func collapse_cell(cell: Cell):
	if cell.possible_states.size() == 0:
		return
	
	var weights = []
	var total_weight = 0.0
	
	for state in cell.possible_states:
		var weight = tiles[state].weight
		weights.append(weight)
		total_weight += weight
	
	var random_value = rng.randf() * total_weight
	var accumulated_weight = 0.0
	
	for i in range(weights.size()):
		accumulated_weight += weights[i]
		if random_value <= accumulated_weight:
			cell.possible_states = [cell.possible_states[i]]
			cell.collapsed = true
			break

func propagate(cell_pos: Vector3):
	var stack = [cell_pos]
	
	while stack.size() > 0:
		var current_pos = stack.pop_back()
		var current_cell = cells[current_pos.z][current_pos.y][current_pos.x]
		
		var directions = [
			["up", Vector3(0, 1, 0)],
			["down", Vector3(0, -1, 0)],
			["north", Vector3(0, 0, -1)],
			["south", Vector3(0, 0, 1)],
			["east", Vector3(1, 0, 0)],
			["west", Vector3(-1, 0, 0)]
		]
		
		for dir in directions:
			var neighbor_pos = current_pos + dir[1]
			if is_valid_position(neighbor_pos):
				var neighbor = cells[neighbor_pos.z][neighbor_pos.y][neighbor_pos.x]
				if update_cell_constraints(neighbor, current_cell, dir[0]):
					stack.append(neighbor_pos)

func update_cell_constraints(cell: Cell, neighbor: Cell, direction: String) -> bool:
	var valid_states = []
	var changed = false
	
	for state in cell.possible_states:
		var is_valid = false
		for neighbor_state in neighbor.possible_states:
			var opposite_dir = get_opposite_direction(direction)
			if tiles[state].possible_neighbors[direction].has(neighbor_state) or \
			   tiles[neighbor_state].possible_neighbors[opposite_dir].has(state):
				is_valid = true
				break
		
		if is_valid:
			valid_states.append(state)
		else:
			changed = true
	
	if valid_states.size() < cell.possible_states.size():
		cell.possible_states = valid_states
	
	return changed

func get_opposite_direction(direction: String) -> String:
	match direction:
		"up": return "down"
		"down": return "up"
		"north": return "south"
		"south": return "north"
		"east": return "west"
		"west": return "east"
	return ""

func is_valid_position(pos: Vector3) -> bool:
	return pos.x >= 0 and pos.x < grid_size.x and \
		   pos.y >= 0 and pos.y < grid_size.y and \
		   pos.z >= 0 and pos.z < grid_size.z

func step() -> bool:
	var cell = get_min_entropy_cell()
	if cell == null:
		return false
	
	collapse_cell(cell)
	propagate(cell.position)
	return true

func run():
	initialize_grid()
	while step():
		pass
	return get_result()

func get_result() -> Array:
	var result = []
	for z in range(grid_size.z):
		var plane = []
		for y in range(grid_size.y):
			var row = []
			for x in range(grid_size.x):
				row.append(cells[z][y][x].possible_states[0] if cells[z][y][x].possible_states.size() > 0 else -1)
			plane.append(row)
		result.append(plane)
	return result

# Helper function to get cell at position
func get_cell(pos: Vector3) -> Cell:
	if is_valid_position(pos):
		return cells[pos.z][pos.y][pos.x]
	return null
