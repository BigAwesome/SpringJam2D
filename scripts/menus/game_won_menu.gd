extends CanvasLayer


var map
var game
var player


# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_tree().get_root().get_node("/root/Game/Map")
	game = get_tree().get_root().get_node("/root/Game")
	player = get_tree().get_root().get_node("/root/Game/Map/Tree")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NextLevel_pressed():
	map._generate()
	game._toggle_win_screne()
	player.get_node("TreeMap").clear()
	# player._reset()
	Score.reset()
	Score.game_paused = false
	Score.tick_delta = 0
