extends Enemy

var damage : int = 5
onready var shoottimer : Timer = $ShootTimer
var spore : PackedScene = preload("res://Ammo/Ammo.tscn")

func _ready():
	health = (Variables.max_health/10)*3
	healthbar.value = health
	healthbar.max_value = health

func _on_ShootTimer_timeout():
	if state != State.DEAD and state != State.DYING:
		var ammo = spore.instance()
		ammo.position = position
		ammo.left = left
		ammo.damage = damage
		ammo.good = false
		#ammo.set_collision_layer_bit(3,false)
		#ammo.set_collision_layer_bit(3,false)
		state = State.SHOOTING
		get_parent().add_child(ammo)

func _on_LeftArea_body_entered(_body):
	if state != State.DEAD and state != State.DYING:
		state = State.IDLE
		sprite.scale.x = 1
		shoottimer.start()

func _on_SightRange_body_exited(_body):
	if state != State.DEAD and state != State.DYING:
		state = State.WALKING
		shoottimer.stop()

func _on_RightArea_body_entered(_body):
	if state != State.DYING or State.DEAD:
		state = State.IDLE
		sprite.scale.x = -1
		shoottimer.start()
