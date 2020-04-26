extends Enemy

onready var _armswinger : AnimationPlayer = $Arm/AnimationPlayer
onready var _armcollider : CollisionShape2D = $Arm/CollisionShape2D
onready var _arm : Area2D = $Arm
onready var _timer :Timer = $Timer
var damage : int = 10

func _ready():
	_armswinger.connect("animation_finished", self, "arm_done")
	health = 40
	healthbar.value = health

func _physics_process(delta):
	if state != State.DEAD and state != State.DYING:
		_arm.scale.x = sprite.scale.x

func _on_Sight_body_exited(body):
	if state != State.DEAD and state != State.DYING:
		state = State.WALKING
		_timer.stop()

func _on_RightArea_body_entered(body):
	if state != State.DEAD and state != State.DYING:
		state = State.IDLE
		sprite.scale.x = -1
		_timer.start()

func _on_LeftArea_body_entered(body):
	if state != State.DEAD and state != State.DYING:
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

func arm_done():
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
