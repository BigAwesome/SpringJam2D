extends Node2D

var tilemap
var seed_tile
var trunks = []


# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = self.get_parent().get_node("TileMap")
	seed_tile = tilemap.world_to_map(self.global_position)
	trunks.append(seed_tile)
	
func _process(delta):
	pass

func _unhandled_input(event):
	if(event.is_action_pressed("mouse_button_left")):
		var clicked_tile = tilemap.world_to_map(get_viewport().get_mouse_position())
		
		if(tilemap.get_cellv(clicked_tile) != 2): #only possible if tile is not stone
			if(clicked_tile.y < seed_tile.y): #over seed can only be trunk
				var trunk = trunks[trunks.size() - 1]
				if(clicked_tile.y == trunk.y - 1 and (clicked_tile.x >= (trunk.x - 1) and clicked_tile.x <= (trunk.x + 1))):
					tilemap.set_cellv(clicked_tile, 1) #place trunk tile
					trunks.append(clicked_tile)
		
		
