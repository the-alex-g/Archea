extends Node

onready var _player : KinematicBody2D = $Player
onready var _music : AudioStreamPlayer = $Music
onready var _doot : Area2D = $Level_Door
var _between : bool = false

func _ready():
	_music.play()
	_load_level()

func _on_Player_dead():
	get_tree().paused = true
	var _error = get_tree().change_scene("res://Main/Main Menu.tscn")

func _load_level():
	var _level : PackedScene
	var _Level : Node
	if _Level != null:
		pass
		#_Level.queue_free()
	if not _between:
		_level = load("res://Levels/Level" + str(Variables.level) + ".tscn")
	if _between:
		_level = load("res://Levels/In_between.tscn")
	_Level = _level.instance()
	var _start = _Level.get_node("Start")
	var _exit = _Level.get_node("Exit")
	add_child(_Level)
	_player.position = _start.global_position
	_doot.position = _exit.global_position
	

func _on_Level_Door_entered():
	_between = !_between
	_load_level()
