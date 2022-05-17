extends Node
## Game Class


## Enums
enum States {
	MAIN_MENU,
	PLAYING,
	PLAYING_AIVSAI
}


## Private Variables
var _state : int = States.MAIN_MENU setget _set_state


## OnReady Variables
onready var hud : Control = get_node("HUD")

onready var main_menu : ColorRect = get_node("HUD/MainMenu")

onready var controls : ColorRect = get_node("HUD/Controls")



## Built-In Virutal Methods
func _ready() -> void:
	hud.visible = true
	controls.visible = false
	_set_state(States.MAIN_MENU)


func _process(delta : float) -> void:
	if Input.is_action_just_released("ui_cancel"):
		if _state == States.PLAYING:
			_set_state(States.MAIN_MENU)


## Private Methods
func _set_state(new_value : int) -> void:
	_state = new_value
	controls.visible = false
	get_tree().paused = _state == States.MAIN_MENU
	main_menu.visible = _state == States.MAIN_MENU


func _on_P1VSP2_pressed():
	_set_state(States.PLAYING)


func _on_P1VSAI_pressed():
	_set_state(States.PLAYING)


func _on_AIVSAI_pressed():
	_set_state(States.PLAYING)


func _on_AIVSAIPlus_pressed():
	_set_state(States.PLAYING)


func _on_Controls_pressed():
	controls.visible = true


func _on_Controls_Close_pressed():
	controls.visible = false
