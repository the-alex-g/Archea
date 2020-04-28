extends Node

onready var _player : KinematicBody2D = $Player

func _ready():
	_load_level()

func _on_Player_dead():
	get_tree().paused = true
	var _error = get_tree().change_scene("res://Main/Main Menu.tscn")

func _load_level():
	var _level : PackedScene = load("res://Levels/In_between.tscn")#("res://Levels/Level" + str(Variables.level) + ".tscn")
	var _Level = _level.instance()
	var _start = _Level.get_node("Start")
	add_child(_Level)
	_player.position = _start.global_position
