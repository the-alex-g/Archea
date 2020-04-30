extends StaticBody2D

onready var sprite : AnimatedSprite = $AnimatedSprite

func hit(_damage):
	sprite.animation = "Open"
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	set_collision_layer_bit(6, false)
	set_collision_mask_bit(6, false)
