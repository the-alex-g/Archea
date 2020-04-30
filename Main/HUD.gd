extends CanvasLayer

onready var _healthbar : ProgressBar = $Control/ProgressBar
onready var _visibility : Node2D = $Visibility
onready var _resume : Button = $Visibility/HBoxContainer/Resume
onready var _main_button : Button = $Visibility/HBoxContainer/Main
onready var _score : Label = $Visibility/VBoxContainer/Score
onready var _health : Label = $Visibility/VBoxContainer/Health
onready var _damage : Label = $Visibility/VBoxContainer/Damage

var _visible : bool = false
var _disabled : bool = true

func _ready():
	_healthbar.value = Variables.health
	_set_pause_menu()
	

func _process(delta):
	_healthbar.value = Variables.health
	_healthbar.max_value = Variables.max_health
	if Input.is_action_just_pressed("escape"):
		_visible = true
		_disabled = false
		get_tree().paused = true
		_set_pause_menu()
		_score.text = "Money:" + str(Variables.score)
		_health.text = "Health: " + str(Variables.health) + " of " + str(Variables.max_health)
		_damage.text = "Sword damage:" + str(Variables.player_damage)

func _on_Resume_pressed():
	get_tree().paused = false
	_visible = false
	_disabled = true
	_set_pause_menu()

func _set_pause_menu():
	_visibility.visible = _visible
	_main_button.disabled = _disabled
	_resume.disabled = _disabled


func _on_Main_pressed():
	var _error = get_tree().change_scene("res://Main/Main Menu.tscn")
