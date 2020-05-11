extends Enemy

onready var _armswinger : AnimationPlayer = $Arm/AnimationPlayer
onready var _armcollider : CollisionShape2D = $Arm/CollisionShape2D
onready var _arm : Area2D = $Arm
onready var _timer :Timer = $Timer
var damage : int = 10

func _ready():
	var _error = _armswinger.connect("animation_finished", self, "arm_done")
	health = (Variables.max_health/10)*4
	healthbar.value = health
	healthbar.max_value = health

func _physics_process(_delta):
	if state != State.DEAD and state != State.DYING:
		_arm.scale.x = sprite.scale.x

func _on_Sight_body_exited(_body):
	if state != State.DEAD and state != State.DYING:
		state = State.WALKING
		_timer.stop()

func _on_RightArea_body_entered(_body):
	if state != State.DEAD and state != State.DYING:
		state = State.IDLE
		sprite.scale.x = -1
		_timer.start()

func _on_LeftArea_body_entered(_body):
	if state != State.DEAD and state != State.DYING:
		state = State.IDLE
		sprite.scale.x = 1
		_timer.start()

func _on_Timer_timeout():
	if state != State.DEAD and state != State.DYING:
		_armcollider.disabled = false
		if left:
			_armswinger.play("Left" + Variables.type)
		else:
			_armswinger.play("Right" + Variables.type)
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
