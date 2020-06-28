extends StaticBody2D

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var _smash : AudioStreamPlayer2D = $AudioStreamPlayer2D
var _right : bool = false

func hit(_damage):
	_smash.play()
	sprite.animation = "Open"
	sprite.scale.x = -1 if _right == true else 1
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	set_collision_layer_bit(6, false)
	set_collision_mask_bit(6, false)
	set_collision_mask_bit(4, false)
	set_collision_layer_bit(4, false)

func _on_Right_body_entered(_body):
	_right = true

func _on_Left_body_entered(_body):
	_right = false
