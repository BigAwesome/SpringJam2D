extends Node2D

enum ui_tiles {
	Unknown,
	Up,
	Down,
	Blocked
}

func get_tree_adjacent(tree, position):
	if(position.y < tree.seed_tile.y): #over seed can only be trunk
			# _build_trunk(tree)
			return ui_tiles.Up
			
	else: #under seed can only be root
			return ui_tiles.Down
			# _build_root(tree)
			
