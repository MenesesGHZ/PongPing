extends Node2D
## Game Logic



## Exported Variables
export(NodePath) var pong : NodePath setget set_pong

export(NodePath) var ping : NodePath setget set_ping



## Private Variables
var _pong

var _ping



## OnReady Variables
func _ready() -> void:
	set_pong(pong)
	set_ping(ping)
	
	match Session.get_currect_view():
		Session.Views.PVP:
			_pong.ai_type = _pong.AiTypes.NONE
			_ping.ai_type = _ping.AiTypes.NONE
		Session.Views.PVAI:
			_pong.ai_type = _pong.AiTypes.NONE
			_ping.ai_type = _ping.AiTypes.QLEARNING
		Session.Views.AIVAI:
			_pong.ai_type = _pong.AiTypes.QLEARNING
			_ping.ai_type = _ping.AiTypes.QLEARNING
		Session.Views.AIVAIP:
			_pong.ai_type = _pong.AiTypes.QLEARNING
			_ping.ai_type = _ping.AiTypes.QLEARNING_PLUS
		Session.Views.AIPVAIP:
			_pong.ai_type = _pong.AiTypes.QLEARNING_PLUS
			_ping.ai_type = _ping.AiTypes.QLEARNING_PLUS


## Public Methods
func set_pong(new_value : NodePath) -> void:
	pong = new_value
	
	if is_inside_tree() and not pong.is_empty():
		_pong = get_node(pong)


func set_ping(new_value : NodePath) -> void:
	ping = new_value
	
	if is_inside_tree() and not ping.is_empty():
		_ping = get_node(ping)
