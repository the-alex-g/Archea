class_name Enemy
extends Actor

enum State{WALKING, DYING, IDLE, SHOOTING, DEAD}
var state = State.WALKING
var left = true
signal dead
onready var collision = $CollisionShape2D
onready var healthbar = $ProgressBar
onready var floor_detector_left = $Left
onready var floor_detector_right = $Right
onready var sprite = $Sprite
onready var animator = $AnimationPlayer
onready var fadeout = $Tween
var money = preload("res://Money/Money.tscn")
var moving = true
var health = 0

func _ready():
	speed.x -= 50
	_velocity.x = -speed.x
	animator.connect("animation_finished", self, "_animation_finished")
	fadeout.connect("tween_all_completed", self, "_fade_finished")

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
		new_anim = "Walk"
	elif state == State.IDLE:
		new_anim = "Idle"
	elif state == State.SHOOTING:
		new_anim = "Shoot"
	elif state == State.DYING:
		collision.disabled = true
		new_anim = "Die"
		emit_signal("dead")
	return new_anim

func _animation_finished(anim_name):
	if anim_name == "Shoot":
		state = State.IDLE
	elif anim_name == "Die":
		state = State.DEAD
		_fade_out()

func _fade_out():
	fadeout.interpolate_property(self, "modulate", null, Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	fadeout.start()

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
