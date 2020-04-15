class_name Ammo
extends Node2D

onready var timer = $Timer
var left = false
var damage = 0

func _physics_process(delta):
	if left == false:
		position.x += 5
	else:
		position.x -= 5
	update()

func _on_Ammo_body_entered(body):
	if body.name == "Player":
		if body.dodging == false:
			body.hit(damage)
			queue_free()
	else:
		queue_free()

func _on_Timer_timeout():
	queue_free()
