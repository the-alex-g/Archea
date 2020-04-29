class_name Player
extends Actor

enum State {FALLING, DYING, WALKING, IDLE, DEAD, DODGING}
onready var sprite : Sprite = $Sprite
onready var detector : RayCast2D = $RayCast2D
onready var collision : CollisionShape2D = $CollisionShape2D
onready var sword  : Area2D= $Sword
onready var animatior : AnimationPlayer = $Sprite/AnimationPlayer
onready var staffcollider : CollisionShape2D = $Sprite/Staff/Staff_Collision
var swinging : bool = false
var state = State.IDLE
var dodging : bool = false
var dropping : bool = false
signal dead
const FLOOR_DETECT_DISTANCE = 20.0

func _ready():
	var camera: Camera2D = $Camera2D
	camera.custom_viewport = $"../.."

func _physics_process(_delta):
	var direction = get_direction()
	var is_jumping
	if Input.is_action_just_pressed("dodge"):
		dodging = true
		state = State.DODGING
		yield(get_tree().create_timer(0.5), 'timeout')
		dodging = false
		state = State.IDLE
	if Input.is_action_just_pressed("ui_down"):
		if detector.is_colliding():
			var thing_hit = detector.get_collider()
			if thing_hit.name == "JumpThrough":
				dropping = true
				_fall_through()
				yield(get_tree().create_timer(0.3), 'timeout')
				_reset_collision()
				dropping = false
	if Input.is_action_just_pressed("swing"):
		swinging = true
		staffcollider.disabled = false
		yield(get_tree().create_timer(0.5), 'timeout')
		swinging = false
		staffcollider.disabled = true
	if Input.is_action_just_released("jump"):
		is_jumping = true
		yield(get_tree().create_timer(0.25), 'timeout')
		is_jumping = false
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jumping)
	var is_on_platform = detector.is_colliding()
	_velocity = move_and_slide(
		_velocity, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)
	if _velocity.x != 0:
		sprite.scale.x = 1 if _velocity.x > 0 else -1
		if is_on_platform and dodging == false:
			state = State.WALKING
	elif _velocity.x == 0:
		state = State.IDLE
	if _velocity.y != 0:
		if is_jumping == false:
			state = State.FALLING
	if dodging and state != State.DODGING:
		state = State.DODGING
		set_collision_layer_bit(1,false)
		set_collision_layer_bit(2,false)
		set_collision_mask_bit(1, false)
		set_collision_mask_bit(2, false)
	elif dodging == false and dropping == false:
		set_collision_layer_bit(1,true)
		set_collision_layer_bit(2,true)
		set_collision_mask_bit(1, true)
		set_collision_mask_bit(2, true)
	var next_anim = _new_anim()
	if next_anim != animatior.current_animation:
		animatior.play(next_anim)

func get_direction():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-1 if is_on_floor() and Input.is_action_just_pressed("jump") else 0
	)

func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jumping
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jumping == false:
		velocity.y = 0.0
	return velocity

func _on_Sword_body_entered(body):
	if swinging == true and body.has_method("hit"):
		body.hit(Variables.player_damage)

func _fall_through():
	set_collision_layer_bit(2,false)
	set_collision_layer_bit(6,false)
	set_collision_mask_bit(2,false)
	set_collision_mask_bit(6,false)
	detector.set_collision_mask_bit(2,false)

func _reset_collision():
	set_collision_layer_bit(2,true)
	set_collision_layer_bit(6,true)
	set_collision_mask_bit(2,true)
	set_collision_mask_bit(6, true)
	detector.set_collision_mask_bit(2,true)

func hit(damage_taken):
	if dodging == false:
		Variables.health -= damage_taken
		if Variables.health <= 0:
			state = State.DEAD
			hide()
			get_tree().paused = true
			yield(get_tree().create_timer(1), "timeout")
			emit_signal("dead")

func _new_anim():
	var next = ""
	if state == State.DODGING:
		next = "Dodging"
	elif state == State.WALKING:
		next = "Walking"
	elif state == State.FALLING:
		next = "Falling"
	elif state == State.IDLE:
		next = "Idle"
	return next
