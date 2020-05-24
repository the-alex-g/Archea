extends RigidBody2D

onready var _flipper : AnimationPlayer = $AnimationPlayer
onready var _sprite  : Sprite = $Sprite
onready var _ding : AudioStreamPlayer = $AudioStreamPlayer
onready var _collision : CollisionShape2D = $CollisionShape2D
var cell : bool

func _ready():
	randomize()
	apply_impulse(Vector2(0,0), Vector2(rand_range(-100,100),rand_range(100,200)))
	_flipper.play("Flip")
	if cell == true:
		_sprite.animation = "Cell"
	else:
		_sprite.animation = "Coin"

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		if cell == false:
			Variables.score += 1
		else:
			Variables.player_damage += 5
			Variables.health += 5
			Variables.max_health += 5
		_ding.play()
		hide()
		_collision.set_deferred("disabled", true)
		yield(get_tree().create_timer(0.15), "timeout")
		queue_free()
