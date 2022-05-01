extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_hit(position):
	var plants = get_tree().get_nodes_in_group("Plant")
	for plant in plants:
		var tiles = plant.get_node("TreeMap")
		if(tiles.get_cell(position.x,position.y) != -1):
			return plant
