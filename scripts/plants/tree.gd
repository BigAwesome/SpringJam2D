extends Node2D

export(bool) var randomPosition
export(Array, Vector2) var spawnArea = [Vector2(),Vector2()] #start tile of the area, end tile of the area
export(Vector2) var spawnPoint

var levelmap
var treemap
var seed_tile
var trunks = []
var roots = []


# Called when the node enters the scene tree for the first time.
func _ready():
	levelmap = self.get_parent().get_node("LevelMap")
	treemap = self.get_node("TreeMap")
	
	_calculate_spawn_point()
	self.global_position = spawnPoint
	treemap.global_position = Vector2(0, 0)
	
	seed_tile = levelmap.world_to_map(self.global_position)
	trunks.append(seed_tile)

func _process(delta):
	pass

func _calculate_spawn_point():
	if(randomPosition):
		var randtest = rand_range(spawnArea[0].x, spawnArea[1].x)
		spawnPoint.x = 64 * int(rand_range(spawnArea[0].x, spawnArea[1].x)) + 32
		spawnPoint.y = 64 * int(rand_range(spawnArea[0].y, spawnArea[1].y)) + 32
	else:
		spawnPoint.x = 64 * spawnPoint.x + 32
		spawnPoint.y = 64 * spawnPoint.y + 32

func _unhandled_input(event):
	if(event.is_action_pressed("mouse_button_left")):
		var clicked_tile = levelmap.world_to_map(get_global_mouse_position())
		
		if(levelmap.get_cellv(clicked_tile) != 0): #only possible if tile is not stone ------------------------- set to acctual tile number later on
			if(clicked_tile.y < seed_tile.y): #over seed can only be trunk
				var trunk = trunks[trunks.size() - 1]
				if(clicked_tile.y == trunk.y - 1 and (clicked_tile.x >= (trunk.x - 1) and clicked_tile.x <= (trunk.x + 1))):
					treemap.set_cellv(clicked_tile, 3) #place trunk tile ------------------------- set to acctual tile number later on
					trunks.append(clicked_tile)
				else:
					print("Trunk needs to be connected to seed")
			else: #under seed can only be root
				#area in which needs to be at least one root
				var start = Vector2(clicked_tile.x - 1, clicked_tile.y - 1) #current roots surrounding: #  #  #
				var end = Vector2(clicked_tile.x + 1, clicked_tile.y - 1)	# "#" is root area			O  x  O
				var index = start											# "O" is empty area			O  O  O
				var surrounding_stones = []
				var root_found = false
				
				while index.y <= end.y:
					var cell = treemap.get_cellv(index)
					if(cell == 4 or index == seed_tile): #if root tile is around ------------------------- set to acctual tile number later on
						
						if(index != start && index != end):
							root_found = true
							break
						else:
							var left_or_right = - 1
							if(index == start): left_or_right = 1
							var no_stone_below = levelmap.get_cellv(Vector2(index.x, index.y + 1)) != 0
							var no_stone_beside = levelmap.get_cellv(Vector2(index.x + (left_or_right), index.y)) != 0
							if(no_stone_below or no_stone_beside):
								root_found = true
								break
					
					if(index.x < end.x):
						index.x = index.x + 1
					else:
						index.y = index.y + 1
						index.x = clicked_tile.x - 1
				
				if(root_found):
					treemap.set_cellv(clicked_tile, 4) #place root tile ------------------------- set to acctual tile number later on
					roots.append(clicked_tile)
				else:
					print("Root needs to be connected to seed")
		else:
			print("Cannot grow on stone")
				
