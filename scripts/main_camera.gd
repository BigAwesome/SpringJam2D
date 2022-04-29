extends Camera2D


# Declare member variables here. Examples:
var lock = true
var start = Vector2()
var delta = Vector2()
export var camera_speed = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	self.make_current()



func _unhandled_input(event):
	if event is InputEventMouseButton:
		if(Input.is_action_just_pressed("mouse_button_right")):
			lock = false
			delta = event.position
			start = self.position
		if(Input.is_action_just_released("mouse_button_right")):
			lock = true
	if(event is InputEventMouseMotion and !lock):
		self.position = start + (event.position - delta) * - camera_speed
