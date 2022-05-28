extends Node2D


var _level_map

enum tiles {
	Unknown,
	Up,
	Down,
	Blocked
}

func _ready():
	_level_map = get_tree().get_nodes_in_group("Map")[1]

func _check_no_diagonal_stones(tile_to_check, top_left_pos):
	var left_or_right = - 1
	if(tile_to_check == top_left_pos): left_or_right = 1
	var no_stone_below = _level_map.get_cellv(Vector2(tile_to_check.x, tile_to_check.y + 1)) != 0
	var no_stone_beside = _level_map.get_cellv(Vector2(tile_to_check.x + (left_or_right), tile_to_check.y)) != 0
	
	return (no_stone_below or no_stone_beside)


func _check_connection_to_seed(tree, position, direction):
	if(direction == tiles.Up):
		return get_trunk_adjacent(tree, position)
		
	else:
		return get_root_adjacent(tree, position)

func get_trunk_adjacent(tree, position):
	var trunk = tree.trunks[tree.trunks.size() - 1]
	if ((position.y == trunk.y - 1 and (position.x >= (trunk.x - 1) and position.x <= (trunk.x + 1)))):
		return tiles.Up
	else:
		return tiles.Blocked

func get_root_adjacent(tree, position):
	#area in which needs to be at least one root
	var start = Vector2(position.x - 1, position.y - 1) 	#current roots surrounding: #  #  #
	var end = Vector2(position.x + 1, position.y - 1)		# "#" is root area			O  x  O
	var index = start										# "O" is empty area			O  O  O

	while index.y <= end.y:
		var cell = tree.treemap.get_cellv(index)
		if(cell == Score.get_tile("roots") or index == tree.seed_tile):
			if(index != start && index != end):
				return tiles.Down
			else:
				if(_check_no_diagonal_stones(index, start)):
					return tiles.Down
		
		if(index.x < end.x):
			index.x = index.x + 1
		else:
			index.y = index.y + 1
			index.x = position.x - 1
	return tiles.Blocked


func get_seed_adjacent(tree, position):
	if(position.y < tree.seed_tile.y):
		# _build_trunk(tree)
		return _check_connection_to_seed(tree, position, tiles.Up)
	   
		
	else: 
		return _check_connection_to_seed(tree, position, tiles.Down)
		# _build_root(tree)
		

func get_tree_adjacent(tree, position):
	return get_seed_adjacent(tree, position)
