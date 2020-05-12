extends RigidBody2D

onready var flipper : AnimationPlayer = $AnimationPlayer
onready var sprite  : Sprite= $Sprite
var cell : bool

func _ready():
	randomize()
	apply_impulse(Vector2(0,0), Vector2(rand_range(-100,100),rand_range(100,200)))
	flipper.play("Flip")
	if cell == true:
		sprite.animation = "Cell"
	else:
		sprite.animation = "Coin"

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		if cell == false:
			Variables.score += 1
		else:
			Variables.player_damage += 5
			Variables.health += 5
			Variables.max_health += 5
		queue_free()
