extends Node

var _get_health : bool = false
var _get_damage : bool = false
var _get_ranged : bool = false

func _process(_delta):
	if Input.is_action_just_pressed("select"):
		if _get_health and Variables.score >= 10:
			Variables.health += 5
			Variables.max_health += 5
			Variables.score -= 10
		elif _get_damage and Variables.score >= 15:
			Variables.player_damage += 5
			Variables.score -= 15
		elif _get_ranged and Variables.score >= 25 and not Variables.ranged: 
			Variables.ranged = true
			Variables.score -= 25

func _on_Health_body_entered(_area):
	_get_health = true

func _on_Damage_body_entered(_body):
	_get_damage = true

func _on_Ranged_body_entered(_body):
	if Variables.ranged == false:
		_get_ranged = true

func _on_Ranged_body_exited(_body):
	_get_ranged = false

func _on_Health_body_exited(_body):
	_get_health = false

func _on_Damage_body_exited(_body):
	_get_damage = false
