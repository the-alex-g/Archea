class_name Enemy
extends Actor

enum State{WALKING, DYING, IDLE, SHOOTING, DEAD, RESURRECT}
onready var collision : CollisionShape2D = $CollisionShape2D
onready var healthbar : ProgressBar = $ProgressBar
onready var floor_detector_left : RayCast2D = $Left
onready var floor_detector_right : RayCast2D = $Right
onready var sprite : Sprite = $Sprite
onready var _hit : AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var animator : AnimationPlayer = $AnimationPlayer
onready var fadeout : Tween = $Tween
var state = State.WALKING
var left : bool = true
var resurrect = false
var money : PackedScene = preload("res://Money/Money.tscn")
var moving : bool = true
var health : int = 0
var damage:int
var alive :bool = true
var type:String = ""
signal dead

func _ready():
	speed.x -= 50
	_velocity.x = -speed.x
	var _error = animator.connect("animation_finished", self, "_animation_finished")
	var _error2 = fadeout.connect("tween_all_completed", self, "_fade_finished")

func _physics_process(_delta):
	if not resurrect:
		left = true if sprite.scale.x == 1 else false
		if state == State.WALKING:
			_velocity = calculate_move_velocity(_velocity)
			_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
			sprite.scale.x = 1 if _velocity.x < 0 else -1
		if state == State.DEAD or state == State.DYING:
			alive = false
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

func hit(damagetaken):
	if alive:
		_hit.play()
		health -= damagetaken
		healthbar.value = health
		if health <= 0:
			healthbar.queue_free()
			Variables.killed_enemy(type)
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
	elif resurrect:
		new_anim = "Resurrect"
	return new_anim

func _animation_finished(anim_name):
	if anim_name == "Shoot":
		state = State.IDLE
	elif anim_name == "Die":
		state = State.DEAD
		_fade_out()
	elif anim_name == "Resurrect":
		alive = true
		resurrect = false
		state = State.WALKING

func _fade_out():
	var _error = fadeout.interpolate_property(self, "modulate", null, Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	var _error2 = fadeout.start()

func _fade_finished():
	var _Value  = rand_range(1,3)
	_Value = int(round(_Value))
	for _x in range(0,_Value):
		var dropped = money.instance()
		dropped.position = get_global_transform().origin
		var cell = rand_range(1,100)
		cell = int(round(cell))
		if cell >= 98:
			dropped.cell = true
		else:
			dropped.cell = false
		get_parent().get_parent().add_child(dropped)
	queue_free()

func save():
	var save_dict = {
		"filename":get_filename(),
		"parent":get_parent().get_path(),
		"pos_x":position.x,
		"pos_y":position.y,
		"damage":damage,
		"health":health,
		"state":state
	}
	return save_dict
