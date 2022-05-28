extends Node2D

var _map
var _level_map

enum tile_names {
	Unknown,
	Up,
	Down,
	Blocked
}

func _ready():
	_map = get_tree().get_nodes_in_group("Map")[0]
	_level_map = get_tree().get_nodes_in_group("Map")[1]
	pass # Replace with function body.


func get_build_conditions(position):
	var trees = get_tree().get_nodes_in_group("Player")
	var outcome = -1
	if(_level_map.get_cellv(position) == Score.get_tile("rock")): return 3
	for tree in trees:
		if(position.y < tree.seed_tile.y): 
			if (position.x <= tree.seed_tile.x+1 or position.x >= tree.seed_tile.x-1):
				outcome = tile_names.Up
			else:
				outcome = tile_names.Blocked
		elif(position.y > tree.seed_tile.y):
			outcome = tile_names.Down
		else: 
			outcome = tile_names.Blocked
	return outcome
	
