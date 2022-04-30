extends Camera2D


# Declare member variables here. Examples:
var lock = true
var start = Vector2()
var delta = Vector2()
export var camera_speed = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()



func _unhandled_input(event):
	if event is InputEventMouseButton:
		if(Input.is_action_just_pressed("mouse_button_right")):
			lock = false
			delta = event.position
			start = position
		if(Input.is_action_just_released("mouse_button_right")):
			lock = true
		if(Input.is_action_just_pressed("mouse_wheel_up")):
			pass
			#zoom = zoom - Vector2(1,1) if zoom > Vector2(1,1) else Vector2(1,1)
		if(Input.is_action_just_pressed("mouse_wheel_down")):
			pass
			#zoom = zoom + Vector2(1,1)
	if(event is InputEventMouseMotion and !lock):
		position = start + (event.position - delta) * - (camera_speed * zoom)
