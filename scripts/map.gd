extends Node2D


# Declare member variables here. Examples:
export var width = 100
export var height = 100
export var difficulty = [-0.2, 0.4, 1] # -1 to 1
onready var tile_map = get_node("LevelMap") 
var _tiles = [] setget set_tiles, get_tiles

var _seed


# Called when the node enters the scene tree for the first time.
func _ready():
	_seed = OpenSimplexNoise.new()
	randomize()
	_seed.set_seed(randi() % 1000000)
	_seed.octaves = 6
	_seed.period = 10
	generate()
	


func generate():
	var i = 0
	for x in range(width):
		for y in range(height):
			var type = _seed.get_noise_2d(x,y)
			#if statement to impletment difficulty into tiles
			if(type <= difficulty[0]):
				type = Score.get_tile("water")
			elif(type <= difficulty[1]):
				type = Score.get_tile("dirt")
			else:
				type = Score.get_tile("rock")
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
