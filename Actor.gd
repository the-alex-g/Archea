class_name Actor
extends KinematicBody2D

export var speed = Vector2(150.0, 350.0)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity") + 10
var _velocity = Vector2.ZERO
const FLOOR_NORMAL = Vector2.UP

func _physics_process(delta):
	_velocity.y += gravity * delta
