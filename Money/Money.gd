extends Area2D

onready var flipper = $AnimationPlayer
export var value = 1

func _ready():
	flipper.play("Flip")

func _on_Area2D_body_entered(body):
	if body.has_method("pickup"):
		body.pickup(value)
		queue_free()
