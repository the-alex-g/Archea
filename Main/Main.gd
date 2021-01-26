extends Node

onready var _player : KinematicBody2D = $Player
onready var _music : AudioStreamPlayer = $Music
onready var _door : Area2D = $Level_Door
onready var _backgroundcolor : AnimationPlayer = $ParallaxBackground/ColorRect/AnimationPlayer
onready var _fogcolor : AnimationPlayer = $Fog/AnimationPlayer
var _not_first : bool = false
var _last : Node = null
signal game_over(won)
signal next_level

func _ready():
	reset()
	Variables.loadval()
	_backgroundcolor.play("Fade")
	_music.play()
	_load_level()
	var save_game := File.new()
	if save_game.file_exists("user://savegame.save"):
		var _error = save_game.open("user://savegame.save", File.READ)
		var content = parse_json(save_game.get_line())
		if content != null:
			load_game()
		save_game.close()
	_fogcolor.play("Fog_Color")

func reset():
	Variables.reset()
	var save_game := File.new()
	var _error = save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(null))
	save_game.close()
	Variables.level = 1

func _load_level():
	var _level : PackedScene
	if _not_first == true:
		_last.queue_free()
	if not Variables.between:
		_level = load("res://Levels/Level" + str(Variables.level) + ".tscn")
	else:
		_level = load("res://Levels/In_between.tscn")
	var _Level : Node = _level.instance()
	if Variables.level == 3:
		var _error = _Level.get_node("Black_Spirit").connect("dead", self, "game_over")
	_last = _Level
	var _start = _Level.get_node("Start")
	var _exit = _Level.get_node("Exit")
	_not_first = true
	add_child(_Level)
	get_tree().paused = false
	_player.position = _start.global_position
	_door.position = _exit.global_position

func _on_Level_Door_entered():
	Variables.between = !Variables.between
	if not Variables.between:
		Variables.level += 1
	_player.invincible = true
	emit_signal("next_level")
	yield(get_tree().create_timer(1), "timeout")
	_load_level()
	yield(get_tree().create_timer(1), "timeout")
	_player.invincible = false

func load_game():
	var save_game := File.new()
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()
	var _error = save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		var new_object = load(node_data["filename"]).instance()
		if new_object.name == "Player":
			_player = new_object
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	save_game.close()
	var follow = get_tree().get_nodes_in_group("Follow")
	for node in follow:
		if node.is_tracking == true:
			node.target = _player

func _on_HUD_save_game():
	Variables.save_game()
	save_game()

func save_game():
	var save_game:File = File.new()
	var _error = save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.filename.empty():
			print(node.name+" Not instanced")
		if !node.has_method("save"):
			print(node.name+" No save method")
		var node_data = node.save()
		save_game.store_line(to_json(node_data))
	save_game.close()
	var _error2 = get_tree().change_scene("res://Main/Main Menu.tscn")


func game_over(won:bool):
	get_tree().paused = true
	reset()
	emit_signal("game_over", won)
