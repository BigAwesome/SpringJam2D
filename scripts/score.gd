extends Node2D


# Declare member variables here. Examples:
onready var plants = []
var ui_node
export var tick = 2
var tick_delta = tick

export var tiles ={"rock": 0, "dirt": 1, "water": 5, "air": -1, "leaf": -1, "trunks": 3, "roots": 4}

export var resource_value = [0, 0, 0, -4, -1, 8, -1]

var owned = [0, 0, 0, 0, 0, 0, 0] # amount of owned tiles
var score = [0, 0, 0, 0, 0, 0, 0] # amount of points (over time)
var power = 10



func get_tile(name):
	return tiles[name]
	
func get_value(name):
	return resource_value[get_tile(name)]

func build_id(id):
	owned[id] += 1
func build_tile(name):
	owned[get_tile(name)] += 1

func _tick_update():
	for i in len(owned):
		score[i] += owned[i] * resource_value[i]
		power += owned[i] * resource_value[i]

# Called when the node enters the scene tree for the first time.
func _ready():
	plants = get_tree().get_nodes_in_group("Plant")
	ui_node = get_tree().get_nodes_in_group("Score")[0]
	#set_resource("roots", score[get_tile("roots")])
	#set_resource("trunks", score[get_tile("trunks")])

func _process(delta):
	ui_node.get_node("Power").text = "Power: " + power as String
	if(tick_delta >= tick):
		tick_delta = 0
		_tick_update()
	else:
		tick_delta += delta
