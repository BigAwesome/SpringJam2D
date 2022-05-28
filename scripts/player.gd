extends Node2D

var _map
var _level_map

enum ui_tiles {
	Unknown,
	Up,
	Down,
	Blocked
}

func _ready():
	_map = get_tree().get_nodes_in_group("Map")[0]
	_level_map = get_tree().get_nodes_in_group("Map")[1]
	pass # Replace with function body.


func get_tree_adjacent(tree, position):
	if(position.y < tree.seed_tile.y): #over seed can only be trunk
			# _build_trunk(tree)
			return ui_tiles.Up
			
	else: #under seed can only be root
			return ui_tiles.Down
			# _build_root(tree)
			


func get_build_conditions(position):
	var trees = get_tree().get_nodes_in_group("Player")
	var outcome = -1
	if(_level_map.get_cellv(position) == Score.get_tile("rock")): return 3
	for tree in trees:
		outcome = get_tree_adjacent(tree, position)
		# if(position.y < tree.seed_tile.y): 
		# 	if (position.x <= tree.seed_tile.x+1 or position.x >= tree.seed_tile.x-1):
		# 		outcome = ui_tiles.Up
		# 	else:
		# 		outcome = ui_tiles.Blocked
		# elif(position.y > tree.seed_tile.y):
		# 	outcome = ui_tiles.Down
		# else: 
		# 	outcome = ui_tiles.Blocked
	return outcome
	
