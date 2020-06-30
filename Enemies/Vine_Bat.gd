extends KinematicBody2D

enum State{FLYING, DYING, DEAD, ASLEEP, WAKING}
onready var _animator:AnimationPlayer = $AnimationPlayer
onready var _sprite:Sprite = $Sprite
onready var _healthbar:ProgressBar = $ProgressBar
onready var _collision : CollisionShape2D = $CollisionShape2D
onready var _hit : AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var _tween:Tween = $Tween
onready var _dirtimer:Timer = $Timer
var state = State.ASLEEP
var _money:PackedScene = preload("res://Money/Money.tscn")
var health:int = 0
var dead:bool = false
var damage:int
var speed:int = 200
var _velocity:Vector2 = Vector2(0,0)
var target = null
var dir:Vector2 = Vector2(0,0)

func _ready():
	health = int(round((Variables.max_health/10.0)*2))
	damage = int(round(Variables.player_damage/2.0))
	_healthbar.value = health
	_healthbar.max_value = health

func _physics_process(delta):
	if state == State.FLYING:
		if dir.length_squared() > 500:
			_velocity = dir.normalized()*speed*delta
			var _error = move_and_collide(_velocity)
	var _animation = get_animation()
	if _animation != _animator.current_animation:
		_animator.play(_animation)

func _on_SightRange_body_entered(body):
	if body is Player and target == null:
		target = body
		state = State.WAKING

func _on_Timer_timeout():
	_change_dir()

func hit(damagetaken):
	_hit.play()
	health -= damagetaken
	_healthbar.value = health
	if health <= 0:
		state = State.DYING
		_healthbar.queue_free()
		Variables.killed_enemy("Vine_Bat")
		_dirtimer.stop()

func get_animation():
	var new_anim = ""
	if state == State.FLYING:
		new_anim = "Fly"
	elif state == State.ASLEEP:
		new_anim = "Asleep"
	elif state == State.WAKING:
		new_anim = "Waking"
	elif state == State.DYING:
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
		state = State.DEAD
		dead = true
		$HitArea/CollisionShape2D2.disabled = true
		_fade_out()
	if anim_name == "Waking":
		state = State.FLYING
		_dirtimer.start(1)
		_change_dir()

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

func _on_HitArea_entered(body):
	if body is Player:
		body.hit(damage)

func _change_dir():
	if get_global_transform().origin < target.get_global_transform().origin:
		_sprite.scale.x = -1
	else:
		_sprite.scale.x = 1
	var _nextdir = target.get_global_transform().origin - get_global_transform().origin
	var _error = _tween.interpolate_property(self, "dir", null, _nextdir, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	var _error2 = _tween.start()

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
