extends Node2D

export(bool) var randomPosition
export(Array, Vector2) var spawnArea = [Vector2(),Vector2()] #start tile of the area, end tile of the area
export(Vector2) var spawnPoint

var map
var levelmap
var treemap
var seed_tile
var trunks = []
var roots = []


# Called when the node enters the scene tree for the first time.
func _ready():
	map = self.get_parent()
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


func _place_tile(tile_pos, tile):
	treemap.set_cellv(tile_pos, tile)
	

func _unhandled_input(event):
	if(event.is_action_pressed("mouse_button_left")):
		_build_on_seed()
		

func _build_on_seed():
	var clicked_tile = levelmap.world_to_map(get_global_mouse_position())
		
	if(clicked_tile.x < map.width && clicked_tile.y < map.height):
		if(levelmap.get_cellv(clicked_tile) != 0): #only possible if tile is not stone ------------------------- set to acctual tile number later on
			if(clicked_tile.y < seed_tile.y): #over seed can only be trunk
				
				_build_trunk(clicked_tile)
				
			else: #under seed can only be root
				
				_build_root(clicked_tile)
				
		else:
			print("Cannot grow on stone")
	else:
		print("Out of map area")
	

func _build_trunk(build_pos):
	
	if(treemap.get_cellv(build_pos) != Score.get_resource("trunks")):
		if(_check_connection_to_seed(build_pos, "trunk")):
			_place_tile(build_pos, Score.get_resource("trunks")) #place trunk tile
			trunks.append(build_pos)
			_add_score(build_pos, "trunks")
		else:
			print("Trunk needs to be connected to seed")
	else:
		print("Already existing trunk at this position")

func _build_root(build_pos):
	if(treemap.get_cellv(build_pos) != Score.get_resource("roots")):
		if(_check_connection_to_seed(build_pos, "root")):
			_place_tile(build_pos, Score.get_resource("roots")) # place root tile
			roots.append(build_pos)
			
			_add_score(build_pos, "roots")
			
		else:
			print("Root needs to be connected to seed")
	else:
		print("Already existing root at this position")


func _check_connection_to_seed(build_pos, tile):
	if(tile == "trunk"):
		var trunk = trunks[trunks.size() - 1]
		return (build_pos.y == trunk.y - 1 and (build_pos.x >= (trunk.x - 1) and build_pos.x <= (trunk.x + 1)))
	else:
		#area in which needs to be at least one root
		var start = Vector2(build_pos.x - 1, build_pos.y - 1) 	#current roots surrounding: #  #  #
		var end = Vector2(build_pos.x + 1, build_pos.y - 1)		# "#" is root area			O  x  O
		var index = start										# "O" is empty area			O  O  O
	
		while index.y <= end.y:
			var cell = treemap.get_cellv(index)
			if(cell == Score.get_resource("roots") or index == seed_tile): #if root tile is around
				
				if(index != start && index != end):
					return true
					break
				else:
					
					if(_check_no_diagonal_stones(index, start)):
						return true
						break
			
			if(index.x < end.x):
				index.x = index.x + 1
			else:
				index.y = index.y + 1
				index.x = build_pos.x - 1
				
		return false

func _check_no_diagonal_stones(tile_to_check, top_left_pos):
	var left_or_right = - 1
	if(tile_to_check == top_left_pos): left_or_right = 1
	var no_stone_below = levelmap.get_cellv(Vector2(tile_to_check.x, tile_to_check.y + 1)) != 0
	var no_stone_beside = levelmap.get_cellv(Vector2(tile_to_check.x + (left_or_right), tile_to_check.y)) != 0
	
	return (no_stone_below or no_stone_beside)

func _add_score(tile_pos, build_tile_name):
	var value = levelmap.get_cellv(tile_pos)
	Score.build_tile(build_tile_name, value)
	if(value == Score.get_tile("water")):
		Score.add_resource("trunks", 1)
