extends Node2D

export(int) var loosing_condition = 0
export(int) var win_tree_height = 10
export(int) var win_tree_leaves = 5

var game_over_scene
var game_win_scene
var ui_node

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_scene = get_node("Camera2D/game_over_menu")
	game_win_scene = get_node("Camera2D/game_won_menu")
	ui_node = get_tree().get_nodes_in_group("Score")[0]
	_toggle_loose_screne()
	_toggle_win_screne()
	pass # Replace with function body.

func _process(_delta):
	if(!Score.game_paused):
		_loose_game(true)
		var tree_height = Score.get_owned()[Score.get_tile("air")]
		var tree_leaves = Score.get_owned()[Score.get_tile("leaves_pink")] + Score.get_owned()[Score.get_tile("leaves_green")]
		if(Score.get_tick_till_next_level() <= 0 or tree_height >= win_tree_height and tree_leaves >= win_tree_leaves):
			_next_level()
	
func _next_level():
	var tree_height = Score.get_owned()[Score.get_tile("air")]
	var tree_leaves = Score.get_owned()[Score.get_tile("leaves_pink")] + Score.get_owned()[Score.get_tile("leaves_green")]
	if(tree_height >= win_tree_height and tree_leaves >= win_tree_leaves):
		Score.game_paused = true
		Score.set_level((Score.get_level() + 1))
		Score.set_trees(1)
		_set_game_won_values()
		win_tree_height += 5
		win_tree_leaves += 5
		_toggle_win_screne()
	else:
		_loose_game(false)
	
func _loose_game(score):
	if(score and Score.get_power() <= loosing_condition or !score):
		Score.game_paused = true
		if(Score.get_trees() > 1):
			Score.set_trees(-1)
			_set_game_over_values(true)
			_toggle_loose_screne()
		else:
			win_tree_height = 10
			win_tree_leaves = 5
			_set_game_over_values(false)
			Score.set_level(1)
			_toggle_loose_screne()
			
func _set_game_won_values():
	var tiles = tiles_owned()
	game_win_scene.get_node("VBoxContainer/WonLevel").text = "Won Level " + Score.get_level() as String
	game_win_scene.get_node("VBoxContainer/OwnedTiles").text = str(tiles)	
		
func _set_game_over_values(trees_left):
	var tiles = tiles_owned()
	if(!trees_left):
		game_over_scene.get_node("VBoxContainer/Level").text = "Level: " + str(Score.get_level())
		game_over_scene.get_node("VBoxContainer/OwnedTiles").text = str(tiles)
		game_over_scene.get_node("VBoxContainer/Seed").visible = false
	else:
		game_over_scene.get_node("VBoxContainer/Level").text = "Level: " + str(Score.get_level())
		game_over_scene.get_node("VBoxContainer/OwnedTiles").text = str(tiles)
		game_over_scene.get_node("VBoxContainer/Seed").visible = true
	
func tiles_owned():
	var tiles_owned = "Dirt: " + str(Score.get_owned()[Score.get_tile("dirt")])
	tiles_owned += " Water: " + str(Score.get_owned()[Score.get_tile("water")])
	tiles_owned += " Trunk: " + str(Score.get_owned()[Score.get_tile("trunks")])
	tiles_owned += " Root: " + str(Score.get_owned()[Score.get_tile("roots")])
	tiles_owned += " Branch: " + str(Score.get_owned()[Score.get_tile("branches")])
	tiles_owned += " Pink Leaves: " + str(Score.get_owned()[Score.get_tile("leaves_pink")])
	tiles_owned += " Green Leaves: " + str(Score.get_owned()[Score.get_tile("leaves_green")])
	return tiles_owned
	
func _toggle_win_screne():
	game_win_scene.get_child(0).visible = !game_win_scene.get_child(0).visible
	game_win_scene.get_child(1).visible = !game_win_scene.get_child(1).visible

func _toggle_loose_screne():
	game_over_scene.get_child(0).visible = !game_over_scene.get_child(0).visible
	game_over_scene.get_child(1).visible = !game_over_scene.get_child(1).visible

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(to_json(node_data))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if(current_line == null):
			continue
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(current_line["filename"]).instance()
		get_node(current_line["parent"]).add_child(new_object)
		new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
		# Now we set the remaining variables.
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, current_line[i])
	save_game.close()
