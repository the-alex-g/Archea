extends Enemy

onready var shoottimer : Timer = $ShootTimer
var spore : PackedScene = preload("res://Ammo/Ammo.tscn")

func _ready():
	health = int(round((Variables.max_health/10.0)*3))
	damage = int(round(Variables.player_damage/2.0))
	healthbar.value = health
	type = "Spitter"
	healthbar.max_value = health

func _on_ShootTimer_timeout():
	if alive:
		var ammo = spore.instance()
		ammo.position = get_global_transform().origin
		ammo.left = left
		ammo.damage = damage
		ammo.good = false
		state = State.SHOOTING
		get_parent().add_child(ammo)

func _on_LeftArea_body_entered(_body):
	if alive:
		state = State.IDLE
		sprite.scale.x = 1
		shoottimer.start()

func _on_SightRange_body_exited(_body):
	if alive:
		state = State.WALKING
		shoottimer.stop()

func _on_RightArea_body_entered(_body):
	if alive:
		state = State.IDLE
		sprite.scale.x = -1
		shoottimer.start()
