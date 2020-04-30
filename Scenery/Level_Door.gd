extends Area2D

var _ready : bool = false
signal entered

func _process(delta):
	if Input.is_action_just_pressed("select"):
		if _ready:
			Variables.level += 1
			emit_signal("entered")

func _on_Level_Door_body_entered(body):
	_ready = true

func _on_Level_Door_body_exited(body):
	_ready = false
