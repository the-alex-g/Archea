extends Node

var ranged : bool = false
var health : int = 100
var score : int = 0
var player_damage : int = 10
var max_health : int = 100
var level : int = 1

func loadval():
	var save_game := File.new()
	if save_game.file_exists("user://Variables.save"):
		var _error = save_game.open("user://Variables.save", File.READ)
		while save_game.get_position() < save_game.get_len():
			var node_data = parse_json(save_game.get_line())
			for i in node_data.keys():
				set(i, node_data[i])
	save_game.close()

func reset():
	var save_game:File = File.new()
	var _error = save_game.open("user://Variables.save", File.WRITE)
	var data = {
		"ranged":false,
		"health":100,
		"score":0,
		"player_damage":10,
		"max_health":100,
		"level":1
	}
	save_game.store_line(to_json(data))
	save_game.close()

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

func save():
	var save_dict := {
		"ranged":ranged,
		"health":health,
		"score":score,
		"player_damage":player_damage,
		"max_health":max_health,
		"level":level
	}
	return save_dict

func save_game():
	var save_game:File = File.new()
	var _error = save_game.open("user://Variables.save", File.WRITE)
	var data = save()
	save_game.store_line(to_json(data))
	save_game.close()
