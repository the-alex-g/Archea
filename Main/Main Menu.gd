extends Node

var dialog = ConfirmationDialog.new()
var already_quitted = false
onready var Quit:Button = $VBoxContainer/Quit
onready var Play:Button = $VBoxContainer/Play
onready var Stats:Button = $VBoxContainer/Stats
onready var Back:Button = $Node/VBoxContainer/Back
onready var TutorialButton:Button = $VBoxContainer/Tutorial

func _ready():
	randomize()
	$ParallaxBackground/ColorRect/AnimationPlayer.play("Fade")
	_set_disabled(false)

func _on_Play_pressed():
	var _error = get_tree().change_scene("res://Main/Main.tscn")

func _on_Quit_pressed():
	if already_quitted == false:
		dialog.dialog_text = "Quit?"
		dialog.get_ok().text = "Yes"
		dialog.get_cancel().text = "No"
		dialog.connect("confirmed", self, "quit")
		dialog.connect("hide", self, "resume")
		add_child(dialog)
	dialog.popup()

func resume():
	already_quitted = true

func quit():
	get_tree().quit()

func _on_Stats_pressed():
	_set_disabled(true)
	generate_stats()

func generate_stats():
	$Node/Spitters.text = "Spitters Killed: "+(str(Variables.get_value("Spitter")))
	$Node/Shamblers.text = "Shamblers Killed: "+(str(Variables.get_value("Shambler")))
	$Node/Snappers.text = "Snappers Killed: "+(str(Variables.get_value("Snapper")))
	$Node/Vine_Bats.text = "Vine Bats Killed: "+(str(Variables.get_value("Vine_Bat")))
	$Node/Corrupted_Spirit.text = "Corrupted Spirits Killed: "+str(Variables.get_value("Corrupted_Spirit"))

func _set_disabled(boolean:bool):
	Quit.disabled = boolean
	TutorialButton.disabled = boolean
	$Node.visible = boolean
	Play.disabled = boolean
	Stats.disabled = boolean
	if boolean:
		Back.disabled = false
	elif not boolean:
		Back.disabled = true

func _on_Back_pressed():
	_set_disabled(false)

func _on_Reset_pressed():
	Variables.set_value("Spitter", 0)
	Variables.set_value("Shambler", 0)
	Variables.set_value("Snapper", 0)
	Variables.set_value("Vine_Bat", 0)
	Variables.set_value("Corrupted_Spirit", 0)
	generate_stats()

func _on_Tutorial_pressed():
	var _error = get_tree().change_scene("res://Levels/Tutorial.tscn")
