extends Node

onready var _player : KinematicBody2D = $Player
onready var _music : AudioStreamPlayer = $Music
onready var _door : Area2D = $Level_Door
var _between : bool = false
var _not_first : bool = false
var _last : Node = null

func _ready():
	_music.play()
	_load_level()

func _on_Player_dead():
	get_tree().paused = true
	var _error = get_tree().change_scene("res://Main/Main Menu.tscn")

func _load_level():
	Variables.type = "_Shroom"
	var _level : PackedScene
	if _not_first == true:
		_last.queue_free()
	if not _between:
		_level = load("res://Levels/Level" + str(Variables.level) + ".tscn")
	if _between:
		_level = load("res://Levels/In_between.tscn")
	var _Level : Node = _level.instance()
	_last = _Level
	var _start = _Level.get_node("Start")
	var _exit = _Level.get_node("Exit")
	_not_first = true
	add_child(_Level)
	_player.position = _start.global_position
	_door.position = _exit.global_position

func _on_Level_Door_entered():
	_between = !_between
	_load_level()
