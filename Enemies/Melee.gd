extends Enemy

onready var _armswinger : AnimationPlayer = $Arm/AnimationPlayer
onready var _armcollider : CollisionShape2D = $Arm/CollisionShape2D
onready var _arm : Area2D = $Arm
onready var _timer :Timer = $Timer

func _ready():
	if state == State.RESURRECT:
		_arm.hide()
	health = int(round((Variables.max_health/10.0)*4))
	damage = Variables.player_damage
	type = "Shambler"
	healthbar.value = health
	healthbar.max_value = health

func _physics_process(_delta):
	if alive:
		_arm.scale.x = sprite.scale.x

func _on_Sight_body_exited(_body):
	if alive:
		state = State.WALKING
		_timer.stop()

func _on_RightArea_body_entered(_body):
	if alive:
		state = State.IDLE
		sprite.scale.x = -1
		_timer.start()

func _on_LeftArea_body_entered(_body):
	if alive:
		state = State.IDLE
		sprite.scale.x = 1
		_timer.start()

func _on_Timer_timeout():
	if state != State.DEAD and state != State.DYING:
		_armcollider.disabled = false
		if left:
			_armswinger.play("Left")
		else:
			_armswinger.play("Right")
		_timer.stop()

func _on_arm_done(_anim_name):
	if state != State.DEAD and state != State.DYING:
		_armcollider.disabled = true
		_timer.start()

func _on_Arm_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage)

func _on_ShroomMan_dead():
	var steve = get_node_or_null("Arm")
	if steve != null:
		_arm.queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Resurrect":
		_arm.show()
