class_name Enemy
extends Actor

enum State{WALKING, DYING, IDLE, SHOOTING, DEAD}
onready var collision : CollisionShape2D = $CollisionShape2D
onready var healthbar : ProgressBar = $ProgressBar
onready var floor_detector_left : RayCast2D = $Left
onready var floor_detector_right : RayCast2D = $Right
onready var sprite : Sprite = $Sprite
onready var animator : AnimationPlayer = $AnimationPlayer
onready var fadeout : Tween = $Tween
var state = State.WALKING
var left : bool = true
var money : PackedScene = preload("res://Money/Money.tscn")
var moving : bool = true
var health : int = 0
signal dead

func _ready():
	speed.x -= 50
	_velocity.x = -speed.x
	var _error = animator.connect("animation_finished", self, "_animation_finished")
	var _error2 = fadeout.connect("tween_all_completed", self, "_fade_finished")

func _physics_process(_delta):
	left = true if sprite.scale.x == 1 else false
	if state == State.WALKING:
		_velocity = calculate_move_velocity(_velocity)
		_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
		sprite.scale.x = 1 if _velocity.x < 0 else -1
	var animation = get_animation()
	if animation != animator.current_animation:
		animator.play(animation)

func calculate_move_velocity(linear_velocity):
	var velocity = linear_velocity
	if not floor_detector_left.is_colliding():
		velocity.x = speed.x
	elif not floor_detector_right.is_colliding():
		velocity.x = -speed.x
	if is_on_wall():
		velocity.x *= -1
	return velocity

func hit(damage):
	health -= damage
	healthbar.value = health
	if health <= 0:
		state = State.DYING

func get_animation():
	var new_anim = ""
	if state == State.WALKING:
		new_anim = "Walk" + Variables.type
	elif state == State.IDLE:
		new_anim = "Idle" + Variables.type
	elif state == State.SHOOTING:
		new_anim = "Shoot" + Variables.type
	elif state == State.DYING:
		collision.disabled = true
		new_anim = "Die" + Variables.type
		emit_signal("dead")
	return new_anim

func _animation_finished(anim_name):
	if anim_name == "Shoot" + Variables.type:
		state = State.IDLE
	elif anim_name == "Die" + Variables.type:
		state = State.DEAD
		_fade_out()

func _fade_out():
	var _error = fadeout.interpolate_property(self, "modulate", null, Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	var _error2 = fadeout.start()

func _fade_finished():
	randomize()
	var dropped = money.instance()
	dropped.position = position
	var Value  = rand_range(1,3)
	Value = int(round(Value))
	dropped.value = Value
	var cell = rand_range(1,100)
	cell = int(round(cell))
	if cell >= 90:
		dropped.cell = true
	else:
		dropped.cell = false
	get_parent().get_parent().add_child(dropped)
	queue_free()
