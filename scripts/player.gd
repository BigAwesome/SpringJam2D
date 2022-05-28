extends Node2D

var _map
var _level_map



func _ready():
	_map = get_tree().get_nodes_in_group("Map")[0]
	_level_map = get_tree().get_nodes_in_group("Map")[1]
	pass # Replace with function body.





func get_build_conditions(position):
	var trees = get_tree().get_nodes_in_group("Player")
	var outcome = -1
	if(_level_map.get_cellv(position) == Score.get_tile("rock")): return 3
	for tree in trees:
		outcome = Rules.get_tree_adjacent(tree, position)
		if(outcome != 3): return outcome

	return outcome
	
