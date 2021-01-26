class_name Ammo
extends Area2D

onready var animation = $AnimationPlayer
var left : bool = false
var good : bool
var black_magic := false
var damage : int = 0

func _ready():
	if good:
		animation.play("Magic")
	elif not black_magic and not good:
		animation.play("Spore")
	else:
		animation.play("Black_Magic")

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
	elif body is Enemy and good or body is Black_Spirit and good or body is VineBat and good:
		body.hit(damage)
		queue_free()
	elif body is TileMap:
		queue_free()

func _on_Timer_timeout():
	queue_free()
