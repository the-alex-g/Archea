extends StaticBody2D

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var _smash : AudioStreamPlayer2D = $AudioStreamPlayer2D
var _right : bool = false
var open:bool = false
var hitalready:bool = false

func _physics_process(_delta):
	if open and not hitalready:
		hit(0)

func hit(damage):
	if damage > 0:
		_smash.play()
	hitalready = true
	sprite.animation = "Open"
	open = true
	sprite.scale.x = -1 if _right == true else 1
	if _right:
		position.x -= 14
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	set_collision_layer_bit(6, false)
	set_collision_mask_bit(6, false)
	set_collision_mask_bit(4, false)
	set_collision_layer_bit(4, false)

func save():
	var savedir := {
		"filename":get_filename(),
		"parent":get_parent().get_path(),
		"pos_x":position.x,
		"pos_y":position.y,
		"open":open
	}
	return savedir

func _on_Right_body_entered(_body):
	_right = true

func _on_Left_body_entered(_body):
	_right = false
