extends Node

var dialog = ConfirmationDialog.new()
var already_quitted = false

func _ready():
	$ParallaxBackground/ColorRect/AnimationPlayer.play("Fade")

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
	$Node.visible = true
	$Node/VBoxContainer/HBoxContainer/Spitters.text = "Spitters Killed: "+(str(Variables.get_value("Spitter")))
	$Node/VBoxContainer/HBoxContainer/Shamblers.text = "Shamblers Killed: "+(str(Variables.get_value("Shambler")))
	$Node/VBoxContainer/HBoxContainer2/Snappers.text = "Snappers Killed: "+(str(Variables.get_value("Snapper")))
	$Node/VBoxContainer/HBoxContainer2/Vine_Bats.text = "Vine Bats Killed: "+(str(Variables.get_value("Vine_Bat")))
