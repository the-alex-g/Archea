extends Area2D

var _ready : bool = false
signal entered

func _process(_delta):
	if Input.is_action_just_pressed("select"):
		if _ready:
			emit_signal("entered")

func _on_Level_Door_body_entered(_body):
	_ready = true

func _on_Level_Door_body_exited(_body):
	_ready = false
