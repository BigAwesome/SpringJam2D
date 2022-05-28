extends Node2D
var level_map
var level_map_mask

var last_hover

func _ready():
	level_map = self.get_parent().get_node("LevelMap")
	level_map_mask = self.get_parent().get_node("UI")

func _unhandled_input(event):
	if(event is InputEventMouseMotion):
		if(last_hover != level_map.world_to_map(get_global_mouse_position())):
			if(last_hover != null):
				level_map_mask.set_cellv(last_hover, -1)
			last_hover = level_map.world_to_map(get_global_mouse_position())
			level_map_mask.set_cellv(last_hover, 1)
