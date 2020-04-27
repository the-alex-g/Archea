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
