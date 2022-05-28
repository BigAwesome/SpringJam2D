extends CanvasLayer


var map
var game
var player
var ui



func _ready():
	map = get_tree().get_root().get_node("/root/Game/Map")
	game = get_tree().get_root().get_node("/root/Game")
	player = get_tree().get_root().get_node("/root/Game/Map/Tree")
	ui = get_tree().get_root().get_node("/root/Game/Map/UI")


func _on_Restart_pressed():
	map._generate()
	game._toggle_loose_screne()
	player.get_node("TreeMap").clear()
	# player._reset()
	Score.reset()
	Score.game_paused = false
	Score.tick_delta = 0
