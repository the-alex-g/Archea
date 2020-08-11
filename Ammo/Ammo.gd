class_name Ammo
extends Area2D

var left : bool = false
var good : bool
var damage : int = 0

func _process(_delta):
	if left == false:
		position.x += 5
	else:
		position.x -= 5
	update()

func _on_Ammo_body_entered(body):
	if body is Player and not good:
		if body.dodging == false:
			body.hit(damage)
			queue_free()
	elif body is Enemy and good:
		body.hit(damage)
		queue_free()

func _on_Timer_timeout():
	queue_free()
