extends Camera2D

export var tile_size = 64
var lock = true
var start = Vector2()
var delta = Vector2()
var map
export var camera_speed = 1
export var sky_limit = 10000


# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_tree().get_nodes_in_group("Map")[0]
	make_current()
	print(position.x)
	print(zoom.x)

func _clamp_move_out_of_map(newPos):
	var clamped_position = newPos
	clamped_position.x = clamp(newPos.x, (0 + OS.window_size.x / 2) * zoom.x, map.width * tile_size - (OS.window_size.x * zoom.x / 2))
	clamped_position.y = clamp(newPos.y, -sky_limit, (map.height * tile_size - (OS.window_size.y * zoom.y / 2)))
	if(newPos != clamped_position):
		return clamped_position
	return newPos

	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if(Input.is_action_just_pressed("mouse_button_right")):
			lock = false
			delta = event.position
			start = position
		if(Input.is_action_just_released("mouse_button_right")):
			lock = true
		if(Input.is_action_just_pressed("mouse_wheel_up")):
			zoom = zoom - Vector2(1,1) if zoom > Vector2(1,1) else Vector2(1,1)
			position = _clamp_move_out_of_map(position)
		if(Input.is_action_just_pressed("mouse_wheel_down")):
			if(zoom + Vector2(1,1) > Vector2(3,3)):
				zoom = Vector2(3,3)
				return
			zoom = zoom + Vector2(1,1)
			position = _clamp_move_out_of_map(position)
	if(event is InputEventMouseMotion and !lock):
		var newPos = start + (event.position - delta) * - (camera_speed * zoom)
		position = _clamp_move_out_of_map(newPos)
		
