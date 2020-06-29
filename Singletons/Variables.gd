extends Node

var ranged : bool = false
var health : int = 100
var score : int = 0
var player_damage : int = 10
var max_health : int = 100
var level : int = 1

func killed_enemy(type:String):
	set_value(type, get_value(type)+1)

func get_value(type:String):
	var f:File = File.new()
	var content
	if f.file_exists("dead_"+type):
		var _error = f.open("dead_"+type, File.READ)
		content = f.get_as_text()
		f.close()
	if content != null:
		return int(content)
	else:
		return 0

func set_value(type:String, value:int):
	var f:File = File.new()
	var _error = f.open("dead_"+type, File.WRITE)
	f.store_string(str(value))
	f.close()
