extends Node2D


# Declare member variables here. Examples:
onready var plants = []
var ui_node
var map
export var tick = 1
var tick_delta = tick
var game_paused = false
var _player_points

export var tiles ={"branches": 6, "leaves_pink": 7, "leaves_green": 8, "water": 10, "rock": 11, "dirt": 12, "roots": 13, "trunks": 14,"air": -1}

export var resource_value = [0, 0, 0 ,0, 0, 0, -2, 6, 4, 0, 8, 0, 0, -2, -4, 0 ]
export var base_score = 10

export var trees = 1
export var level = 1

export var base_ticks_till_next_level = 60
var ticks_till_next_level = base_ticks_till_next_level

var player_seed = preload("res://nodes/plants/tree.tscn")


var bot = preload("res://nodes/plants/bot_tree.tscn")
export var spawn_time = 2
export var max_bots = 10
var spawn_time_delta = 0


func get_tile(name):
	if(name == null):
		 return -1
	return tiles[name]
	
func get_value(name):
	return resource_value[get_tile(name)]
func get_power():
	return _player_points.get_power()
func get_owned():
	return _player_points.get_owned()
func build_id(id):
	_player_points.build_id(id)
func build_tile(name):
	_player_points.build_tile(name)
func drop_id(id):
	_player_points.drop_id(id)
func drop_tile(name):
	_player_points.drop_tile(name)
	
func get_trees():
	return trees
func set_trees(value):
	trees += value
func get_level():
	return level
func set_level(value):
	level = value
func get_tick_till_next_level():
	return ticks_till_next_level
func set_tick_till_next_level(value):
	ticks_till_next_level = value
func reset():
	tick_delta = 0
	set_tick_till_next_level(base_ticks_till_next_level * get_level())
	_player_points._reset()
	_player_points.tick_update()
	game_paused = false
	delete_player_and_bots()
	spawn_player_seeds()

func delete_player_and_bots():
	for i in self.get_parent().get_node("Game/Map").get_child_count():
		var test = self.get_parent().get_node("Game/Map").get_child(i)
		if(i == 0 or i == 1):
			continue
		self.get_parent().get_node("Game/Map").get_child(i).queue_free()

func spawn_player_seeds():
	for i in trees - 1:
		var tree = player_seed.instance()
		map.add_child(tree)

func _tick_update():
	_player_points.tick_update()
	spawn_time_delta += 1
	if(spawn_time_delta >= spawn_time ):
		if(len(get_tree().get_nodes_in_group("Bot")) < max_bots):
			var node = bot.instance()
			node.spawnArea = [Vector2(1,1), Vector2(map.height-1,map.width-1)]
			map.add_child(node)
			node.set_owner(map)
		spawn_time_delta = 0
	ticks_till_next_level -= 1
		
# Called when the node enters the scene tree for the first time.
func _ready():
	_player_points = Points.new()
	plants = get_tree().get_nodes_in_group("Plant")
	ui_node = get_tree().get_nodes_in_group("Score")[0]
	map = get_tree().get_nodes_in_group("Map")[0]
	#set_resource("roots", score[get_tile("roots")])
	#set_resource("trunks", score[get_tile("trunks")])

func _process(delta):
	_set_ui()
	if(tick_delta >= tick):
		tick_delta = 0
		if(!game_paused): _tick_update()
	else:
		tick_delta += delta

func _set_ui():
	var leaves = _player_points.get_owned()[get_tile("leaves_pink")] + _player_points.get_owned()[get_tile("leaves_green")]
	
	ui_node.get_node("LevelTicker").text = "Till next level: " + get_tick_till_next_level() as String
	ui_node.get_node("Seed").text = "Seeds: " + get_trees() as String
	ui_node.get_node("Level").text = "Level: " + get_level() as String
	ui_node.get_node("Power").text = "Power: " + _player_points.get_power() as String
	ui_node.get_node("Trunks").text = "Tree over ground: " + _player_points.get_owned()[get_tile("air")] as String + "/" + get_node("/root/Game").win_tree_height as String
	ui_node.get_node("Leaves").text = "Leaves: " + leaves as String + "/" + get_node("/root/Game").win_tree_leaves as String

class Points:
	var _owned = [] # amount of owned tiles
	var _score = [] # amount of points (over time)
	var _power = Score.base_score * Score.level
	func _init():
		for i in len(Score.resource_value):
			_owned.append(0)
			_score.append(0)
		
	func _reset():
		for i in len(Score.resource_value):
			_owned[i] = 0
			_score[i] = 0
		reset_power()
	func get_tile(name):
		return Score.tiles[name]
	func get_value(name):
		return Score.resource_value[get_tile(name)]
	func build_id(id):
		_owned[id] += 1
	func build_tile(name):
		_owned[get_tile(name)] += 1
	func drop_id(id):
		_owned[id] -= 1
	func drop_tile(name):
		_owned[get_tile(name)] -= 1
	func get_power():
		return _power
	func reset_power():
		_power = Score.base_score * Score.level
	func get_owned():
		return _owned
	func tick_update():
		for i in len(_owned):
			_score[i] += _owned[i] * Score.resource_value[i]
			_power += _owned[i] * Score.resource_value[i]
