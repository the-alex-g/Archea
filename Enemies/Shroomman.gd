extends Enemy

onready var armswinger = $Arm/AnimationPlayer
onready var armcollider = $Arm/CollisionShape2D
onready var arm = $Arm
onready var timer = $Timer
var damage = 1

func _ready():
	armswinger.connect("animation_finished", self, "arm_done")
	health = 40
	healthbar.value = health

func _physics_process(delta):
	if state != State.DEAD and state != State.DYING:
		arm.scale.x = sprite.scale.x

func _on_Sight_body_exited(body):
	if state != State.DEAD and state != State.DYING:
		state = State.WALKING
		timer.stop()

func _on_RightArea_body_entered(body):
	if state != State.DEAD and state != State.DYING:
		state = State.IDLE
		sprite.scale.x = -1
		timer.start()

func _on_LeftArea_body_entered(body):
	if state != State.DEAD and state != State.DYING:
		state = State.IDLE
		sprite.scale.x = 1
		timer.start()

func _on_Timer_timeout():
	if state != State.DEAD and state != State.DYING:
		armcollider.disabled = false
		if left:
			armswinger.play("Left")
		else:
			armswinger.play("Right")
		timer.stop()

func arm_done():
	if state != State.DEAD and state != State.DYING:
		armcollider.disabled = true
		timer.start()

func _on_Arm_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage)

func _on_ShroomMan_dead():
	var steve = get_node_or_null("Arm")
	if steve != null:
		arm.queue_free()
