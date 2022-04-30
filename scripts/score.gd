extends Node2D


# Declare member variables here. Examples:
onready var plants = []
var ui_node
var trunks 
var roots 

export var ground_tile_names = {"rock": 0, "dirt": 1, "water": 5, "air": -1, "leaf": 5} 
export var ground_tile_values = [0, -1, 0, -1, -1, 5]
export var player_resource_names = {"roots": 0, "trunks": 1}
export var player_resource_score = [5, 0]



func get_tile(name):
	return ground_tile_names[name]
	
func get_value(name):
	return ground_tile_values[ground_tile_names[name]]

func get_resource(name):
	return player_resource_names[name]

func set_resource(name, value):
	player_resource_score[get_resource(name)] = value
	
func build_tile(name, tile):
	add_resource(name,ground_tile_values[tile])

func add_resource(name, amount):
	player_resource_score[get_resource(name)] += amount
	
# Called when the node enters the scene tree for the first time.
func _ready():
	plants = get_tree().get_nodes_in_group("Plant")
	ui_node = get_tree().get_nodes_in_group("Score")[0]
	set_resource("roots", player_resource_score[get_resource("roots")])
	set_resource("trunks", player_resource_score[get_resource("trunks")])
	trunks = ui_node.get_node("Trunks")
	roots = ui_node.get_node("Roots")

func _process(delta):
	trunks.text = player_resource_score[get_resource("trunks")] as String
	roots.text = player_resource_score[get_resource("roots")] as String
