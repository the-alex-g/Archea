extends KinematicBody2D

enum State{FLYING, DYING, DEAD, ASLEEP}
onready var _animatior:AnimationPlayer = $AnimationPlayer
onready var _sprite:Sprite = $Sprite
onready var _healthbar:ProgressBar = $ProgressBar
onready var _collision : CollisionShape2D = $CollisionShape2D
onready var _hit : AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var _fadeout : Tween = $Tween
onready var _dirtimer:Timer = $Timer
var _state = State.ASLEEP
var _money:PackedScene = preload("res://Money/Money.tscn")
var health:int = 0
var damage:int
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
		if get_global_transform().origin < target.get_global_transform().origin:
			_sprite.scale.x = -1
		else:
			_sprite.scale.x = 1

func _on_SightRange_body_entered(body):
	if body is Player and target == null:
		target = body
		_state = State.FLYING
		_dirtimer.start(1)

func _on_Timer_timeout():
	dir = target.get_global_transform().origin - get_global_transform().origin
