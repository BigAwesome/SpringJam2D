extends Node2D

export(bool) var randomPosition
export(Array, Vector2) var spawnArea = [Vector2(),Vector2()] #start tile of the area, end tile of the area
export(Vector2) var spawnPoint

var map
var levelmap
var treemap
var seed_tile
var trunks = []
var branches = []
var leaf_que = []
var roots = []

var tick = 0
var tick_delta = 0
var last_leaf_branch = 0
export var leaf_grow_time = [5,10]
var hold = false
var last_click


# Called when the node enters the scene tree for the first time.
func _ready():
	map = self.get_parent()
	levelmap = self.get_parent().get_node("LevelMap")
	treemap = self.get_node("TreeMap")
	spawnArea = [Vector2(1, 1),Vector2(map.width, map.height/(2*Score.get_level()))]
	
	_calculate_spawn_point()
	self.global_position = spawnPoint
	treemap.global_position = Vector2(0, 0)
	
	seed_tile = levelmap.world_to_map(self.global_position)
	trunks.append(seed_tile)

func _process(delta):
	
	if(len(leaf_que) > 0):
		var i = 0
		for leaf in leaf_que:
			leaf_que[i].time -= delta
			if(leaf_que[i].time <= 0):
				_grow_leaves(leaf_que[i].position, leaf_que[i].type)
				leaf_que.remove(i)
				leaf_que.sort()
			i += 1
		
		
func _reset():
	trunks = []
	branches = []
	leaf_que = []
	roots = []
	last_leaf_branch = 0
	
	_calculate_spawn_point()
	self.global_position = spawnPoint
	seed_tile = levelmap.world_to_map(self.global_position)
	trunks.append(seed_tile)
	
	self.global_position = spawnPoint
	treemap.global_position = Vector2(0, 0)

func _grow_leaves(position, type):
	var leave_color = Score.get_tile(("leaves_green"))
	if(type): leave_color = Score.get_tile(("leaves_pink"))
	_place_tile(position, leave_color)
	Score.build_id(leave_color)
	Score.drop_tile("branches")
	last_leaf_branch += 1
	

func _calculate_spawn_point():
	if(randomPosition):
		spawnPoint.x = 64 * int(rand_range(spawnArea[0].x, spawnArea[1].x)) + 32
		spawnPoint.y = 64 * int(rand_range(spawnArea[0].y, spawnArea[1].y)) + 32
	else:
		spawnPoint.x = 64 * spawnPoint.x + 32
		spawnPoint.y = 64 * spawnPoint.y + 32
	get_tree().get_nodes_in_group("Camera")[0].position = spawnPoint


func _place_tile(tile_pos, tile):
	treemap.set_cellv(tile_pos, tile)
	

func _unhandled_input(event):
	if(event.is_action_pressed("mouse_button_left")):
		hold = true
		_build_on_seed()
		last_click = levelmap.world_to_map(get_global_mouse_position())
	if(event.is_action_released("mouse_button_left")):
		hold = false
	if(event is InputEventMouseMotion):
		if(last_click != levelmap.world_to_map(get_global_mouse_position()) && hold == true):
			_build_on_seed()
			last_click = levelmap.world_to_map(get_global_mouse_position())
	

func _build_on_seed():
	var clicked_tile = levelmap.world_to_map(get_global_mouse_position())
	if(treemap.get_cellv(clicked_tile) != -1):
		return
	var collision = HitScan.get_hit(clicked_tile)
	if(collision != null && collision != self):
		return
	if(clicked_tile.x >= 0 && clicked_tile.x < map.width && clicked_tile.y < map.height):
		if(levelmap.get_cellv(clicked_tile) != Score.get_tile("rock")): #only possible if tile is not stone ------------------------- set to acctual tile number later on
			if(clicked_tile.y < seed_tile.y): #over seed can only be trunk
				
				_build_trunk(clicked_tile)
				
			else: #under seed can only be root
				
				_build_root(clicked_tile)
				
		else:
			pass
			#print("Cannot grow on stone")
	else:
		pass
		#print("Out of map area")
	

func _build_trunk(build_pos):
	if(treemap.get_cellv(build_pos) != Score.get_tile("trunks")):
		var can_be_trunk = _check_connection_to_seed(build_pos, "trunk")
		if(can_be_trunk != "false" && can_be_trunk != null):
			_place_tile(build_pos, Score.get_tile(can_be_trunk)) #place trunk tile
			_add_score(build_pos, can_be_trunk)
		else:
			pass
			#print("Trunk needs to be connected to seed")
	else:
		pass
		#print("Already existing trunk at this position")

func _build_root(build_pos):
	if(treemap.get_cellv(build_pos) != Score.get_tile("roots")):
		var can_be_root = _check_connection_to_seed(build_pos, "root")
		if(can_be_root != "false"):
			_place_tile(build_pos, Score.get_tile(can_be_root)) # place root tile

			roots.append(build_pos)
			
			_add_score(build_pos, "roots")
			
		else:
			pass
			#print("Root needs to be connected to seed")
	else:
		pass
		#print("Already existing root at this position")


func _check_trunk_above_ground(build_pos):
	var last_trunk = trunks[trunks.size() - 1]
	if((build_pos.y == last_trunk.y - 1 and (build_pos.x >= (last_trunk.x - 1) and build_pos.x <= (last_trunk.x + 1)))):
		trunks.append(build_pos)
		return "trunks"
	else:
		var left = Vector2((build_pos.x + 1), build_pos.y)
		var right = Vector2((build_pos.x - 1), build_pos.y)
		if((trunks.find(left) != -1 or trunks.find(right) != -1) or (branches.find(left) != -1 or branches.find(right) != -1)):
			branches.append(build_pos)
			leaf_que.append({
				"position":build_pos, 
				"time":rand_range(leaf_grow_time[0], leaf_grow_time[1]),
				"type":(randi() % 2) as bool
				})
			#print("next to branch")
			return "branches"
	

func _check_connection_to_seed(build_pos, tile):
	if(tile == "trunk"):
		var selected_cell = levelmap.get_cellv(build_pos)
		if(selected_cell == -1):
			return _check_trunk_above_ground(build_pos)
		else:
			var trunk = trunks[trunks.size() - 1]
			if ((build_pos.y == trunk.y - 1 and (build_pos.x >= (trunk.x - 1) and build_pos.x <= (trunk.x + 1)))):
				trunks.append(build_pos)
				return "trunks"
			else:
				return "false"
	else:
		#area in which needs to be at least one root
		var start = Vector2(build_pos.x - 1, build_pos.y - 1) 	#current roots surrounding: #  #  #
		var end = Vector2(build_pos.x + 1, build_pos.y - 1)		# "#" is root area			O  x  O
		var index = start										# "O" is empty area			O  O  O
	
		while index.y <= end.y:
			var cell = treemap.get_cellv(index)
			if(cell == Score.get_tile("roots") or index == seed_tile): #if root tile is around
				
				if(index != start && index != end):
					return "roots"
				else:
					if(_check_no_diagonal_stones(index, start)):
						return "roots"
			
			if(index.x < end.x):
				index.x = index.x + 1
			else:
				index.y = index.y + 1
				index.x = build_pos.x - 1
				
		return "false"

func _check_no_diagonal_stones(tile_to_check, top_left_pos):
	var left_or_right = - 1
	if(tile_to_check == top_left_pos): left_or_right = 1
	var no_stone_below = levelmap.get_cellv(Vector2(tile_to_check.x, tile_to_check.y + 1)) != 0
	var no_stone_beside = levelmap.get_cellv(Vector2(tile_to_check.x + (left_or_right), tile_to_check.y)) != 0
	
	return (no_stone_below or no_stone_beside)

func _add_score(tile_pos, build_tile_name):
	var collision = HitScan.get_hit(tile_pos)
	if(collision != null && collision != self):
		return
		#print(self, "----", collision)
		#collision.get_parent().remove_child(collision)
	var value = levelmap.get_cellv(tile_pos)
	Score.build_tile(build_tile_name)
	Score.build_id(value)
	#if(value == Score.get_tile("water")):
		#Score.build_tile("trunks")
	treemap.update_bitmask_region(tile_pos, Vector2(map.width, map.height))
