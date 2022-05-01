extends Node2D

export(int) var loosing_condition = 0

var game_over_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_scene = get_node("Camera2D/game_over_menu")
	_toggle_loose_screne()
	pass # Replace with function body.

func _process(delta):
	_loose_game()
	
func _loose_game():
	if(Score.get_power() <= loosing_condition):
		get_tree().paused = true
		_set_game_over_values()
		_toggle_loose_screne()
		
func _set_game_over_values():
	game_over_scene.get_node("VBoxContainer/Level").text = "Level: " + str(Score.get_level())
	game_over_scene.get_node("VBoxContainer/OwnedTiles").text = str(Score.get_owned())
	

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
