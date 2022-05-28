extends Node2D

var _player_trees
var _level_map
var _level_map_mask

var _last_hover

func _ready():
	_level_map = self.get_parent().get_node("LevelMap")
	_level_map_mask = self.get_parent().get_node("UI")
	_player_trees = get_tree().get_nodes_in_group("Player")
	

func _unhandled_input(event):
	if!(event is InputEventMouseMotion): return
	var position = _level_map.world_to_map(get_global_mouse_position())
	if(_last_hover == position): return
	if(_last_hover != null): _level_map_mask.set_cellv(_last_hover, -1)
	var collision = HitScan.get_hit(position)
	var map_tile = _level_map.get_cellv(position)
	# print(map_tile, "---", collision, "---", position)
	_last_hover = position
	_level_map_mask.set_cellv(
		_last_hover, 
		Player.get_build_conditions(position) 
	)
