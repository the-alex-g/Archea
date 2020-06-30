extends Enemy

func _ready():
	state = State.IDLE
	health = int(round((Variables.max_health/10.0)*5))
	damage = Variables.player_damage*2
	healthbar.value = health
	type = "Snapper"
	healthbar.max_value = health

func _on_Sighted_body_exited(_body):
	if alive:
		state = State.IDLE

func _on_Right_body_entered(_body):
	if alive:
		state = State.WALKING
		speed.x = abs(speed.x)

func _on_Left_body_entered(_body):
	if alive:
		state = State.WALKING
		speed.x = -speed.x

func _on_HitArea_body_entered(body):
	if alive:
		if body.has_method("hit"):
			body.hit(damage)

func _on_Guytrap_dead():
	$HitArea/CollisionShape2D.disabled = true
