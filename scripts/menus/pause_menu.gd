extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var game = get_node("..")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SaveButton_button_down():
	game.save_game()


func _on_LoadButton_button_down():
	game.load_game()
