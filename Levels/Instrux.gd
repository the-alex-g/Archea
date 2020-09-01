extends Area2D

onready var text:Label = $Label

func _ready():
	text.visible = false

func _on_Instrux_body_entered(body):
	if body is Player:
		text.visible = true

func _on_Instrux_body_exited(body):
	if body is Player:
		text.visible = false
