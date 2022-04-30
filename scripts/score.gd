extends Node2D


# Declare member variables here. Examples:
onready var plants = []
var ui_node
var cells 

export var ground_tile_names = {"rock": 0, "dirt": 1, "water": 2, "air": -1, "leaf": 5} 
export var ground_tile_values = [0, -1, 5, -1]
export var player_resource_names = {"cells": 0}
export var player_resource_score = [10]



func get_tile(name):
	return ground_tile_names[name]
	
func get_value(name):
	return ground_tile_values[ground_tile_names[name]]

func get_resource(name):
	return player_resource_names[name]

func set_resource(name, value):
	player_resource_score[get_resource(name)] = value
func build_tile(name, amount):
	player_resource_score[get_resource(name)] += ground_tile_values[amount]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	plants = get_tree().get_nodes_in_group("Plant")
	ui_node = get_tree().get_nodes_in_group("Score")[0]
	set_resource("cells", player_resource_score[get_resource("cells")])
	cells = ui_node.get_node("Cells")

func _process(delta):
	cells.text = player_resource_score[get_resource("cells")] as String
