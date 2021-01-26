extends CanvasLayer

onready var _healthbar : ProgressBar = $Control/ProgressBar
onready var _visibility : Node2D = $Visibility
onready var _resume : Button = $Visibility/VBoxContainer/Resume
onready var _main_button : Button = $Visibility/VBoxContainer/Main
onready var _score : Label = $Visibility/VBoxContainer/Score
onready var _money : Label = $Money
onready var _health : Label = $Visibility/VBoxContainer/Health
onready var _damage : Label = $Visibility/VBoxContainer/Damage
onready var _blackout := $ColorRect
signal save_game
var _visible : bool = false
var _disabled : bool = true

func _ready():
	_blackout.color = Color(0,0,0,0)
	_healthbar.value = Variables.health
	_set_pause_menu()

func _process(_delta):
	_money.text = str(Variables.score)
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
	emit_signal("save_game")

func _next_level():
	$Tween.interpolate_property(_blackout, "color", Color(0,0,0,0), Color(0,0,0,1), 1)
	$Tween.start()
	yield(get_tree().create_timer(1), "timeout")
	$Tween.interpolate_property(_blackout, "color", Color(0,0,0,1), Color(0,0,0,0), 1)
	$Tween.start()

func game_over(won:bool):
	_visibility.hide()
	$Control.hide()
	$Money.hide()
	$Tween.interpolate_property(_blackout, "color", Color(0,0,0,0), Color(0,0,0,1), 1)
	$Tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	match won:
		true:
			$Label.text = "You have cleansed the forest of the blight"
		false:
			$Label.text = "You have been stopped... For a time"
	$Label.visible = true
