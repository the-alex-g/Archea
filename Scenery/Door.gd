extends StaticBody2D

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var _smash : AudioStreamPlayer2D = $AudioStreamPlayer2D

func hit(_damage):
	_smash.play()
	sprite.animation = "Open"
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	set_collision_layer_bit(6, false)
	set_collision_mask_bit(6, false)
