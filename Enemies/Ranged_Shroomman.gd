extends Enemy

var damage = 5
onready var shoottimer = $ShootTimer
var spore = preload("res://Ammo/Ammo.tscn")

func _ready():
	health = 30
	healthbar.value = health

func _on_ShootTimer_timeout():
	if state != State.DEAD and state != State.DYING:
		var ammo = spore.instance()
		ammo.position = position
		ammo.left = left
		ammo.damage = damage
		state = State.SHOOTING
		get_parent().add_child(ammo)

func _on_LeftArea_body_entered(body):
	if state != State.DEAD and state != State.DYING:
		state = State.IDLE
		sprite.scale.x = 1
		shoottimer.start()

func _on_SightRange_body_exited(body):
	if state != State.DEAD and state != State.DYING:
		state = State.WALKING
		shoottimer.stop()

func _on_RightArea_body_entered(body):
	if state != State.DYING or State.DEAD:
		state = State.IDLE
		sprite.scale.x = -1
		shoottimer.start()
