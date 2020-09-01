extends Area2D

var _ready : bool = false

func _process(_delta):
	if _ready and Input.is_action_just_pressed("select"):
		var _error = get_tree().change_scene("res://Main/Main Menu.tscn")

func _on_Level_Door_body_entered(_body):
	_ready = true

func _on_Level_Door_body_exited(_body):
	_ready = false
