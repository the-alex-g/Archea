extends Node

var scene = preload("res://Levels/Level1.tscn")
onready var player = $Player
onready var resume = $Player/HBoxContainer/Resume
onready var quit = $Player/HBoxContainer/Main
onready var buttons = $Player/HBoxContainer
onready var labels = $Player/VBoxContainer
onready var weapondisplay = $Player/VBoxContainer/WeaponLabel
onready var healthdisplay = $Player/VBoxContainer/Health
var pause_menu_visible = false
var pause_menu_disabled = true

func _ready():
	var Scene = scene.instance()
	add_child(Scene)
	var start = str(get_path_to(Scene)) + "/Start"
	player.transform = $Level1/Start.transform
	var skycolor = $Level1/ParallaxBackground/ColorRect/AnimationPlayer
	skycolor.play("Fade")

func _physics_process(delta):
	if Input.is_action_just_released("escape"):
		pause_menu_disabled = false
		pause_menu_visible = true
		weapondisplay.text = str("Weapon damage ", player.damage)
		healthdisplay.text = str(player.health, " of ", player.healthbar.max_value, " health.")
		_set_pause_menu()
		get_tree().paused = true

func _set_pause_menu():
	buttons.visible = pause_menu_visible
	labels.visible = pause_menu_visible
	resume.disabled = pause_menu_disabled
	quit.disabled = pause_menu_disabled

func _on_Resume_pressed():
	get_tree().paused = false
	pause_menu_disabled = true
	pause_menu_visible = false
	_set_pause_menu()

func _on_Main_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Main/Main Menu.tscn")

func _on_Player_dead():
	get_tree().paused = false
	get_tree().change_scene("res://Main/Main Menu.tscn")
