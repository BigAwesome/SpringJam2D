extends Camera2D

export var tile_size = 64
export var tile_size_extention = 64
var lock = true
var start = Vector2()
var delta = Vector2()
var map
export var camera_speed = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_tree().get_nodes_in_group("Map")[0]
	make_current()

func _detect_zoom_out_of_map():

	#print((OS.window_size.x*zoom.x)/tile_size)
	if((OS.window_size.x * zoom.x)/tile_size >= map.width - OS.window_size.x/tile_size/2) or ((OS.window_size.y * zoom.x)/tile_size >= map.height - OS.window_size.x/tile_size/2):
		#print("extend")
		map.width += tile_size_extention
		map.height += tile_size_extention
		map._generate()
		
func _detect_move_out_of_map():
	if((OS.window_size.x + position.x)/tile_size >= map.width - OS.window_size.x/tile_size/2) or ((OS.window_size.y + position.y)/tile_size >= map.height - OS.window_size.x/tile_size/2):
		#print("extend")
		map.width += tile_size_extention
		map.height += tile_size_extention
		map._generate()
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if(Input.is_action_just_pressed("mouse_button_right")):
			lock = false
			delta = event.position
			start = position
		if(Input.is_action_just_released("mouse_button_right")):
			lock = true
		if(Input.is_action_just_pressed("mouse_wheel_up")):
			_detect_zoom_out_of_map()
			zoom = zoom - Vector2(1,1) if zoom > Vector2(1,1) else Vector2(1,1)
		if(Input.is_action_just_pressed("mouse_wheel_down")):
			_detect_zoom_out_of_map()
			zoom = zoom + Vector2(1,1)
	if(event is InputEventMouseMotion and !lock):
		_detect_move_out_of_map()
		position = start + (event.position - delta) * - (camera_speed * zoom)
