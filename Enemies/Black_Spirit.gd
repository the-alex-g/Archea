class_name Black_Spirit
extends Actor

enum State {FALLING, DYING, WALKING, IDLE, DEAD, DODGING}
onready var sprite : Sprite = $Sprite
onready var detector : RayCast2D = $RayCast2D
onready var collision : CollisionShape2D = $CollisionShape2D
onready var animatior : AnimationPlayer = $Sprite/AnimationPlayer
onready var staffcollider : CollisionShape2D = $Sprite/Staff/Staff_Collision
onready var dodge_timer : Timer = $DodgeTimer
onready var stafftip : Position2D = $Sprite/Stafftip
onready var healthbar : ProgressBar = $ProgressBar
var swinging : bool = false
var player_is_close := false
var state = State.IDLE
var health:int = 200
var player_is_detected := false
var _attack : String = ""
var player_is_right := false
var dodgable : bool = true
var dodging : bool = false
var dropping : bool = false
var is_shooting := false
var can_shoot := true
var is_jumping
signal dead(won)
const FLOOR_DETECT_DISTANCE = 20.0

func _ready():
	randomize()
	if not is_connected("dead", get_parent(), "_on_Player_dead"):
		var _error = connect("dead", get_parent(), "_on_Player_dead")

func _physics_process(_delta):
	healthbar.value = health
	var direction := Vector2(0 if player_is_detected == false else 0 if swinging == true else 1 if player_is_right == true else -1, 1 if is_jumping else 0)
	if player_is_detected == true:
		var random := randi()%5
		if random == 0 or random == 1:
			if not swinging and can_shoot:
				swinging = true
				_attack = "_Shoot"
				var _magic : PackedScene = load("res://Ammo/Ammo.tscn")
				var _Magic : Node = _magic.instance()
				_Magic.good = false
				_Magic.position = stafftip.global_position
				_Magic.damage = 5
				_Magic.black_magic = true
				if sprite.scale.x == 1:
					_Magic.left = false
				else:
					_Magic.left = true
				get_parent().add_child(_Magic)
				yield(get_tree().create_timer(0.5), 'timeout')
				_attack = ""
				yield(get_tree().create_timer(0.5), "timeout")
				swinging = false
		elif random == 2 or random == 3:
			if not player_is_close:
				can_shoot = false
				yield(get_tree().create_timer(1), "timeout")
				can_shoot = true
			if not swinging and player_is_close:
				swinging = true
				_attack = "_Swing"
				staffcollider.disabled = false
				yield(get_tree().create_timer(0.5), 'timeout')
				_attack = ""
				swinging = false
				staffcollider.disabled = true
		elif random == 4:
			if not swinging:
				swinging = true
				var rand_enemy := randi()%2
				var enemy:Resource
				if rand_enemy == 0:
					enemy = load("res://Enemies/Ranged.tscn")
				elif rand_enemy == 1:
					enemy = load("res://Enemies/Melee.tscn")
				var summoned:Enemy = enemy.instance()
				summoned.state = summoned.State.RESURRECT
				summoned.alive = false
				summoned.resurrect = true
				summoned.position = Vector2(global_position.x + 100.0 if player_is_right == true else -100.0, global_position.y)
				get_parent().add_child(summoned)
				yield(get_tree().create_timer(2), "timeout")
				swinging = false
	_velocity = calculate_move_velocity(_velocity, direction, speed)
	var is_on_platform = detector.is_colliding()
	_velocity = move_and_slide(
		_velocity, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)
	sprite.scale.x = direction.x if direction.x > 0.0 else 1.0 if player_is_right == true else -1.0
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

func jump():
	if not is_jumping:
		is_jumping = true
		yield(get_tree().create_timer(0.25), 'timeout')
		is_jumping = false

func dodge_action():
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

func calculate_move_velocity(
		linear_velocity,
		direction,
		speed
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
		body.hit(10)

func hit(damage_taken):
	if dodging == false:
		health -= damage_taken
		if health <= 0:
			state = State.DEAD
			queue_free()
			Variables.killed_enemy("Corrupted_Spirit")
			emit_signal("dead", true)

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

func _on_Right_body_entered(_body):
		player_is_right = true
		player_is_detected = true

func _on_Left_body_entered(_body):
		player_is_right = false
		player_is_detected = true

func avoid():
	var random = randi()%4
	if random == 0:
		dodge_action()
	elif random == 1 or random == 2:
		jump()

func _on_Hit_Area_body_entered(_body):
		player_is_close = true
		avoid()

func _on_Hit_Area_area_entered(_area):
		dodge_action()

func _on_Hit_Area_body_exited(_body):
		player_is_close = false
