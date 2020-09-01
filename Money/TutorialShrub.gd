extends Node2D

onready var _fadeout : Tween = $Tween
onready var _collision : CollisionShape2D = $Right/CollisionShape2D
onready var _collision2:CollisionShape2D = $Left/CollisionShape2D
var _colliding : bool = false
var _money : PackedScene= load("res://Money/Money.tscn")

func _physics_process(_delta):
	if Input.is_action_just_pressed("swing") or Input.is_action_just_pressed("select") or Input.is_action_just_pressed("ranged_attack"):
		if _colliding:
			var _Value  = 25-Variables.score
			for _x in range(0,_Value):
				var _dropped = _money.instance()
				_dropped.position = position
				_dropped.cell = false
				get_parent().get_parent().add_child(_dropped)
			_collision.disabled = true
			_collision2.disabled = true
			var _error = _fadeout.interpolate_property(self, "modulate", null, Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
			var _error2 = _fadeout.start()


func _on_Tween_tween_all_completed():
	queue_free()

func _on_Left_body_entered(_body):
	_colliding = true

func _on_Right_body_entered(_body):
	_colliding = true

func _on_Left_body_exited(_body):
	_colliding = false

func _on_Right_body_exited(_body):
	_colliding = false
