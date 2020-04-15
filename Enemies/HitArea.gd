extends StaticBody2D

var Damage

func _ready():
	pass

func _on_Enemy_damage_update(damage):
	Damage = damage
