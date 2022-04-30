extends Node2D


# Declare member variables here. Examples:
export var width = 20
export var height = 20
export var difficulty = [10, 80, 10]
onready var tile_map = get_node("LevelMap") 
var _tiles = [] setget set_tiles, get_tiles


# Called when the node enters the scene tree for the first time.
func _ready():
	_generate()


func _generate():
	
	randomize()
	var i = 0
	for x in range(width):
		for y in range(height):
			var type = randi() % 100
			#if statement to impletment difficulty into tiles
			type = Score.get_tile("rock") if type <= difficulty[0] else Score.get_tile("dirt") if type >= difficulty[0] && type <= difficulty[1] else Score.get_tile("water")
			_tiles.append(type)
			tile_map.set_cell(x,y,_tiles[i])
			i = i + 1
	tile_map.update_bitmask_region(Vector2(), Vector2(height, width))

func set_tiles(tiles):
	var i = 0
	for x in range(width):
		for y in range(height):
			_tiles[i] = tiles[i]
			tile_map.set_cell(x,y,tiles[i])
			i = i + 1
	
func get_tiles ():
	return _tiles
func save():
	var tiles = []
	for x in range(width):
		for y in range(height): 
			tiles.append(tile_map.get_cell(x,y))
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"width": width, 
		"height": height,
		"tiles": tiles
	}
	return save_dict
