extends Node

onready var player : KinematicBody2D = $Player
onready var skycolor : AnimationPlayer = $ParallaxBackground/ColorRect/AnimationPlayer

func _ready():
	skycolor.play("Fade")

func _on_Player_dead():
	get_tree().paused = true
	get_tree().change_scene_to(Variables.main_menu)
