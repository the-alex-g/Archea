extends Area2D

var _get_ranged := false

func _process(_delta):
	if _get_ranged and Variables.score >= 25 and not Variables.ranged and Input.is_action_just_pressed("select"): 
			Variables.ranged = true
			Variables.score -= 25

func _on_Ranged_body_entered(body):
	if body is Player:
		_get_ranged = true

func _on_Ranged_body_exited(body):
	if body is Player:
		_get_ranged = false
