extends Node

var scene = preload("res://Levels/Level1.tscn")
onready var player = $Player
onready var resume = $Player/HBoxContainer/Resume
onready var quit = $Player/HBoxContainer/Main
onready var pauselabel = $Player/VBoxContainer/Pause
onready var weapondisplay = $Player/VBoxContainer/WeaponLabel
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
		_set_pause_menu()
		get_tree().paused = true

func _set_pause_menu():
	weapondisplay.visible = pause_menu_visible
	pauselabel.visible = pause_menu_visible
	quit.disabled = pause_menu_disabled
	quit.visible = pause_menu_visible
	resume.visible = pause_menu_visible
	resume.disabled = pause_menu_disabled

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
