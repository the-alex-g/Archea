extends KinematicBody2D

enum State{FLYING, DYING, DEAD, ASLEEP}
onready var _animator:AnimationPlayer = $AnimationPlayer
onready var _sprite:Sprite = $Sprite
onready var _healthbar:ProgressBar = $ProgressBar
onready var _collision : CollisionShape2D = $CollisionShape2D
#onready var _hit : AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var _tween:Tween = $Tween
onready var _dirtimer:Timer = $Timer
var _state = State.ASLEEP
var _money:PackedScene = preload("res://Money/Money.tscn")
var health:int = 0
var dead:bool = false
var _damage:int
var speed:int = 200
var _velocity:Vector2 = Vector2(0,0)
var target = null
var dir:Vector2 = Vector2(0,0)

func _ready():
	health = int(round((Variables.max_health/10.0)*2))
	_healthbar.value = health
	_healthbar.max_value = health

func _physics_process(delta):
	if _state == State.FLYING:
		if dir.length_squared() > 500:
			_velocity = dir.normalized()*speed*delta
			var _error = move_and_collide(_velocity)
	var _animation = get_animation()
	if _animation != _animator.current_animation:
		_animator.play(_animation)

func _on_SightRange_body_entered(body):
	if body is Player and target == null:
		target = body
		_state = State.FLYING
		_dirtimer.start(1)
		_on_Timer_timeout()

func _on_Timer_timeout():
	if get_global_transform().origin < target.get_global_transform().origin:
		_sprite.scale.x = -1
	else:
		_sprite.scale.x = 1
	var _nextdir = target.get_global_transform().origin - get_global_transform().origin
	var _error = _tween.interpolate_property(self, "dir", null, _nextdir, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	var _error2 = _tween.start()

func hit(damage):
	#_hit.play()
	health -= damage
	_healthbar.value = health
	if health <= 0:
		_state = State.DYING
		_dirtimer.stop()

func get_animation():
	var new_anim = ""
	if _state == State.FLYING:
		new_anim = "Fly"
	elif _state == State.ASLEEP:
		new_anim = "Asleep"
	elif _state == State.DYING:
		_collision.disabled = true
		new_anim = "Die"
		set_collision_layer_bit(9, true)
		set_collision_mask_bit(9, true)
	return new_anim

func _fade_out():
	var _error = _tween.interpolate_property(self, "modulate", null, Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	var _error2 = _tween.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Die":
		_state = State.DEAD
		dead = true
		_fade_out()

func _on_tween_all_completed():
	if dead:
		randomize()
		var _Value  = rand_range(1,3)
		_Value = int(round(_Value))
		for _x in range(0,_Value):
			randomize()
			var dropped = _money.instance()
			dropped.position = get_global_transform().origin
			var cell = rand_range(1,100)
			cell = int(round(cell))
			if cell >= 98:
				dropped.cell = true
			else:
				dropped.cell = false
			get_parent().get_parent().add_child(dropped)
		queue_free()
