extends Node2D

export(bool) var randomPosition
export(Array, Vector2) var spawnArea = [Vector2(),Vector2()] #start tile of the area, end tile of the area
export(Vector2) var spawnPoint

var tilemap
var seed_tile
var trunks = []
var roots = []


# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = self.get_parent().get_node("TileMap")
	seed_tile = tilemap.world_to_map(self.global_position)
	trunks.append(seed_tile)
	
	if(randomPosition):
		var randtest = rand_range(spawnArea[0].x, spawnArea[1].x)
		spawnPoint.x = 64 * int(rand_range(spawnArea[0].x, spawnArea[1].x)) + 32
		spawnPoint.y = 64 * int(rand_range(spawnArea[0].y, spawnArea[1].y)) + 32
	
	self.global_position = spawnPoint
	
func _process(delta):
	var test = tilemap.world_to_map(get_viewport().get_mouse_position())
	print(tilemap.get_cellv(test))
	pass

func _unhandled_input(event):
	if(event.is_action_pressed("mouse_button_left")):
		var clicked_tile = tilemap.world_to_map(get_viewport().get_mouse_position())
		
		if(tilemap.get_cellv(clicked_tile) != 2): #only possible if tile is not stone ------------------------- set to acctual tile number later on
			if(clicked_tile.y < seed_tile.y): #over seed can only be trunk
				var trunk = trunks[trunks.size() - 1]
				if(clicked_tile.y == trunk.y - 1 and (clicked_tile.x >= (trunk.x - 1) and clicked_tile.x <= (trunk.x + 1))):
					tilemap.set_cellv(clicked_tile, 1) #place trunk tile ------------------------- set to acctual tile number later on
					trunks.append(clicked_tile)
			else: #under seed can only be root
				#area in which needs to be at least one root
				var index = Vector2(clicked_tile.x - 1, clicked_tile.y - 1) #current roots surrounding: #  #  #
				var end = Vector2(clicked_tile.x + 1, clicked_tile.y - 1)	# "#" is root area			O  x  O
				var root_found = false										# "O" is empty area			O  O  O
				
				while index.y <= end.y:
					var cell = tilemap.get_cellv(index)
					if(cell == 2 or index == seed_tile): #if root tile is around ------------------------- set to acctual tile number later on
						root_found = true
						break
					
					if(index.x < end.x):
						index.x = index.x + 1
					else:
						index.y = index.y + 1
						index.x = clicked_tile.x - 1
				
				if(root_found):
					tilemap.set_cellv(clicked_tile, 2) #place root tile ------------------------- set to acctual tile number later on
					roots.append(clicked_tile)
		else:
			print("Cannot grow on stone")
				
