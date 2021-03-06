class_name Player
extends Actor

enum State {FALLING, DYING, WALKING, IDLE, DEAD, DODGING}
onready var sprite : Sprite = $Sprite
onready var detector : RayCast2D = $RayCast2D
onready var collision : CollisionShape2D = $CollisionShape2D
onready var animatior : AnimationPlayer = $Sprite/AnimationPlayer
onready var staffcollider : CollisionShape2D = $Sprite/Staff/Staff_Collision
onready var dodge_timer : Timer = $DodgeTimer
onready var stafftip : Position2D = $Sprite/Stafftip
var swinging : bool = false
var state = State.IDLE
var _attack : String = ""
var dodgable : bool = true
var invincible := false
var dodging : bool = false
var dropping : bool = false
signal dead(won)
const FLOOR_DETECT_DISTANCE = 20.0

func _ready():
	if not is_connected("dead", get_parent(), "_on_Player_dead"):
		var _error = connect("dead", get_parent(), "_on_Player_dead")
	var camera: Camera2D = $Camera2D
	camera.custom_viewport = $"../.."

func _physics_process(_delta):
	var direction = get_direction()
	var is_jumping
	if Input.is_action_just_pressed("dodge"):
		if not dodging and dodgable:
			dodging = true
			state = State.DODGING
			dodge()
			yield(get_tree().create_timer(0.5), 'timeout')
			dodging = false
			dodge_timer.start()
			dodgable = false
			undodge()
			state = State.IDLE
	if Input.is_action_just_pressed("DropThrough"):
		if detector.is_colliding():
			var thing_hit = detector.get_collider()
			if thing_hit.name == "JumpThrough":
				dropping = true
				_fall_through()
				yield(get_tree().create_timer(0.3), 'timeout')
				_reset_collision()
				dropping = false
	if Input.is_action_just_pressed("swing"):
		if not swinging:
			swinging = true
			_attack = "_Swing"
			staffcollider.disabled = false
			yield(get_tree().create_timer(0.5), 'timeout')
			_attack = ""
			swinging = false
			staffcollider.disabled = true
	if Input.is_action_just_pressed("ranged_attack"):
		if not swinging and Variables.ranged:
			swinging = true
			_attack = "_Shoot"
			var _magic : PackedScene = load("res://Ammo/Ammo.tscn")
			var _Magic : Node = _magic.instance()
			_Magic.good = true
			_Magic.position = stafftip.global_position
			_Magic.damage = int(round(Variables.player_damage/2.0))
			if sprite.scale.x == 1:
				_Magic.left = false
			else:
				_Magic.left = true
			get_parent().add_child(_Magic)
			yield(get_tree().create_timer(0.5), 'timeout')
			_attack = ""
			swinging = false
	if Input.is_action_just_released("jump"):
		if is_jumping == false:
			is_jumping = true
			yield(get_tree().create_timer(0.25), 'timeout')
			is_jumping = false
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jumping)
	var is_on_platform = detector.is_colliding()
	_velocity = move_and_slide(
		_velocity, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)
	sprite.scale.x = get_direction().x if get_direction().x != 0 else sprite.scale.x
	if _velocity.x != 0:
		if is_on_platform and dodging == false:
			state = State.WALKING
	elif _velocity.x == 0:
		state = State.IDLE
	if _velocity.y != 0:
		if is_jumping == false:
			state = State.FALLING
	if dodging:
		state = State.DODGING
		var _error = move_and_slide(Vector2(sprite.scale.x*speed.x*2, 0), Vector2.UP)
	var next_anim = _new_anim(_velocity)
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
	if not dodging:
		velocity.x = speed.x * direction.x
		if direction.y != 0.0:
			velocity.y = speed.y * direction.y
		if is_jumping == false:
			velocity.y = 0.0
	return velocity

func _on_Staff_body_entered(body):
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
	if dodging == false and not invincible:
		Variables.health -= damage_taken
		if Variables.health <= 0:
			state = State.DEAD
			hide()
			get_tree().paused = true
			emit_signal("dead", false)

func _new_anim(_velocity):
	var next : String = ""
	if state == State.DODGING:
		next = "Dodging" 
	elif state == State.WALKING:
		next = "Walking" + _attack
	elif state == State.FALLING:
		next = "Falling" + _attack
	elif state == State.IDLE:
		next = "Idle" + _attack
	if _velocity.y < 0:
		next = "Jumping" + _attack
	elif _velocity.y > 0.1:
		next = "Falling" + _attack
	return next

func undodge():
	set_collision_layer_bit(1,true)
	set_collision_layer_bit(2,true)
	set_collision_mask_bit(1, true)
	set_collision_mask_bit(2, true)

func dodge():
	state = State.DODGING
	set_collision_layer_bit(1,false)
	set_collision_layer_bit(2,false)
	set_collision_mask_bit(1, false)
	set_collision_mask_bit(2, false)

func _on_DodgeTimer_timeout():
	dodgable = true

func save():
	var save_dict = {
		"filename":get_filename(),
		"parent":get_parent().get_path(),
		"pos_x":position.x,
		"pos_y":position.y,
		"state":state
	}
	return save_dict
