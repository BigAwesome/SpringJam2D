extends Node2D


# Declare member variables here. Examples:
onready var plants = []
var ui_node
var map
export var tick = 2
var tick_delta = tick
var _player_points

export var tiles ={"rock": 0, "dirt": 1, "water": 5, "air": -1, "leaf": -1, "trunks": 3, "roots": 4}

export var resource_value = [0, 0, 0, -4, -1, 8, -1]



var bot = preload("res://nodes/plants/bot_tree.tscn")
export var spawn_time = 5
var spawn_time_delta = 0


func get_tile(name):
	return tiles[name]
	
func get_value(name):
	return resource_value[get_tile(name)]

func build_id(id):
	_player_points.build_id(id)
func build_tile(name):
	_player_points.build_tile(name)

func _tick_update():
	_player_points._tick_update()
	spawn_time_delta += 1
	
	if(spawn_time_delta == spawn_time):
		var node = bot.instance()
		node.spawnArea = [Vector2(), Vector2(map.height,map.width)]
		map.add_child(node)
		node.set_owner(map)
		spawn_time_delta = 0
		
# Called when the node enters the scene tree for the first time.
func _ready():
	_player_points = Points.new()
	plants = get_tree().get_nodes_in_group("Plant")
	ui_node = get_tree().get_nodes_in_group("Score")[0]
	map = get_tree().get_nodes_in_group("Map")[0]
	#set_resource("roots", score[get_tile("roots")])
	#set_resource("trunks", score[get_tile("trunks")])

func _process(delta):
	ui_node.get_node("Power").text = "Power: " + _player_points.get_power() as String
	if(tick_delta >= tick):
		tick_delta = 0
		_tick_update()
	else:
		tick_delta += delta

class Points:
	var _owned = [0, 0, 0, 0, 0, 0, 0] # amount of owned tiles
	var _score = [0, 0, 0, 0, 0, 0, 0] # amount of points (over time)
	var _power = 10
	func _init():
		pass
		
	func get_tile(name):
		return Score.tiles[name]
	func get_value(name):
		return Score.resource_value[get_tile(name)]
	func build_id(id):
		_owned[id] += 1
	func build_tile(name):
		_owned[get_tile(name)] += 1
	func get_power():
		return _power
	func _tick_update():
		for i in len(_owned):
			_score[i] += _owned[i] * Score.resource_value[i]
			_power += _owned[i] * Score.resource_value[i]
