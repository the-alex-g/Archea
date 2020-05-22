extends Area2D

onready var _fadeout : Tween = $Tween
onready var _collision : CollisionShape2D = $CollisionShape2D
var _colliding : bool = false
var _money : PackedScene= load("res://Money/Money.tscn")

func _physics_process(_delta):
	if Input.is_action_just_pressed("swing") or Input.is_action_just_pressed("select") or Input.is_action_just_pressed("ranged_attack"):
		if _colliding:
			randomize()
			var _Value  = rand_range(3,5)
			_Value = int(round(_Value))
			for _x in range(0,_Value):
				randomize()
				var _dropped = _money.instance()
				_dropped.position = position
				var _cell = rand_range(1,100)
				_cell = int(round(_cell))
				if _cell >= 98:
					_dropped.cell = true
				else:
					_dropped.cell = false
				get_parent().get_parent().add_child(_dropped)
			_collision.disabled = true
			var _error = _fadeout.interpolate_property(self, "modulate", null, Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
			var _error2 = _fadeout.start()


func _on_Tween_tween_all_completed():
	queue_free()

func _on_Shrub_body_entered(_body):
	_colliding = true

func _on_Shrub_body_exited(_body):
	_colliding = false
