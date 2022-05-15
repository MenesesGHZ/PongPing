extends Node
## Game Class


## Enums
enum States {
	MAIN_MENU,
	PLAYING,
}


## Private Variables
var _state : int = States.MAIN_MENU setget _set_state


## OnReady Variables
onready var main_menu : ColorRect = get_node("HUD/MainMenu")



## Private Methods
func _set_state(new_value : int) -> void:
	_state = new_value
	main_menu.visible = _state == States.MAIN_MENU


func _on_P1VSP2_pressed():
	_set_state(States.PLAYING)


func _on_P1VSAI_pressed():
	_set_state(States.PLAYING)


func _on_AIVSAI_pressed():
	_set_state(States.PLAYING)


func _on_AIVSAIPlus_pressed():
	_set_state(States.PLAYING)
