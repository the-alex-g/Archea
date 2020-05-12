extends Enemy

export var damage : int= 20

func _ready():
	state = State.IDLE
	health = (Variables.max_health/10)*5
	healthbar.value = health
	healthbar.max_value = health

func _on_Sighted_body_exited(_body):
	if state != State.DEAD and state != State.DYING:
		state = State.IDLE

func _on_Right_body_entered(_body):
	if state != State.DEAD and state != State.DYING:
		state = State.WALKING
		speed.x = abs(speed.x)

func _on_Left_body_entered(_body):
	if state != State.DEAD and state != State.DYING:
		state = State.WALKING
		speed.x = -speed.x

func _on_HitArea_body_entered(body):
	if state != State.DEAD and state != State.DYING:
		if body.has_method("hit"):
			body.hit(damage)
