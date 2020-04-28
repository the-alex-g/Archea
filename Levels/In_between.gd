extends Node

var _get_health : bool = false
var _get_damage : bool = false
var _get_ranged : bool = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("select"):
		if _get_health and Variables.score >= 10:
			Variables.health += 5
			Variables.max_health += 5
			Variables.score -= 10
		elif _get_damage and Variables.score >= 15:
			Variables.player_damage += 5
			Variables.score -= 15
		elif _get_ranged and Variables.score >= 25:
			Variables.ranged = true
			Variables.score -= 25

func _on_Health_area_entered(area):
	_get_health = true

func _on_Damage_body_entered(body):
	_get_damage = true

func _on_Ranged_body_entered(body):
	if Variables.ranged == false:
		_get_ranged = true

func _on_Ranged_body_exited(body):
	_get_ranged = false

func _on_Health_body_exited(body):
	_get_health = false

func _on_Damage_body_exited(body):
	_get_damage = false
