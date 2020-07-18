extends RigidBody2D

onready var _animatior : AnimationPlayer = $AnimationPlayer
onready var _ding : AudioStreamPlayer = $AudioStreamPlayer
onready var _collision : CollisionShape2D = $CollisionShape2D
onready var _areacollison : CollisionShape2D = $Area2D/CollisionShape2D
var cell : bool

func _ready():
	apply_impulse(Vector2(0,0), Vector2(rand_range(-100,100),rand_range(100,200)))
	if cell == true:
		_animatior.play("Leaf")
	else:
		_animatior.play("Coin")

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
		_areacollison.set_deferred("disabled", true)
		yield(get_tree().create_timer(0.15), "timeout")
		queue_free()
