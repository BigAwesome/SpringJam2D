extends Node2D

func _ready():
	pass # Replace with function body.

func get_build_conditions(position):
	var trees = get_tree().get_nodes_in_group("Player")
	var outcome = -1
	for tree in trees:
		if(position.y < tree.seed_tile.y): 
			if (position.x <= tree.seed_tile.x+1 or position.x >= tree.seed_tile.x-1):
				outcome = 1
			else:
				outcome = 3
		elif(position.y > tree.seed_tile.y):
			outcome = 2
		else: 
			outcome = 3
	return outcome
	
