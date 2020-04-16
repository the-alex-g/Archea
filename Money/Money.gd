extends Area2D

onready var flipper = $AnimationPlayer
onready var sprite = $Sprite
export var value = 1
var cell

func _ready():
	flipper.play("Flip")
	if cell == true:
		sprite.animation = "cell"
	else:
		sprite.animation = "Coin"

func _on_Area2D_body_entered(body):
	if body.has_method("pickup"):
		if cell == false:
			body.pickup(value)
		else:
			body.damage += 5
			body.health += 5
			body.healthbar.max_value += 5
			body.healthbar.value = body.health
		queue_free()
