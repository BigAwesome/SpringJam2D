extends TileMap


# Declare member variables here. Examples:
export var width = 20
export var height = 50
export var difficulty = [10, 80, 10]
var rocks = []
var earth = []
var water = []


# Called when the node enters the scene tree for the first time.
func _ready():
	_generate()


func _generate():
	
	for x in range(width):
		for y in range(height):
			var type = randi() % 100
			#if statement to impletment difficulty into tiles
			type = 0 if type <= difficulty[0] else 1 if type >= difficulty[0] && type <= difficulty[1] else 2
			
			if(type == 0):
				rocks.append([x,y])
			elif(type == 1):
				earth.append([x,y])
			elif(type == 2):
				water.append([x,y])
			set_cell(x,y,type)
