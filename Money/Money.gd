extends Area2D

onready var flipper : AnimationPlayer = $AnimationPlayer
onready var sprite  : Sprite= $Sprite
export var value : int = 1
var cell : bool

func _ready():
	flipper.play("Flip")
	if cell == true:
		sprite.animation = "cell"
	else:
		sprite.animation = "Coin"

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		if cell == false:
			Variables.score += value
		else:
			Variables.player_damage += 5
			Variables.health += 5
			Variables.max_health += 5
		queue_free()
