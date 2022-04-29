extends TileMap


# Declare member variables here. Examples:
export var width = 20
export var height = 50
export var difficulty = [10, 80, 10]
var rocks = [[]]
#var earth = [[]]
var water = [[]]



# Called when the node enters the scene tree for the first time.
func _ready():
	_generate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _generate():
	
	for x in range(width):
		for y in range(height):
			var type = randi()%100
			type = 0 if type <= difficulty[0] else 1 if type >= difficulty[0] && type <= difficulty[1] else 2
			self.set_cell(x,y,type)
