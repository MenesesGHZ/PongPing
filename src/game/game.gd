extends Node2D
## Game Logic



## Exported Variables
export(NodePath) var pong : NodePath setget set_pong

export(NodePath) var ping : NodePath setget set_ping

## Preloads
const QLearning = preload("res://src/game/ai/q_learning.tscn")


## Private Variables
var _pong

var _ping

var _q_learning

## OnReady Variables
func _ready() -> void:
	set_pong(pong)
	set_ping(ping)
	
	match Session.get_currect_view():
		Session.Views.PVP:
			setup_PVP()
			_pong.ai_type = _pong.AiTypes.NONE
			_ping.ai_type = _ping.AiTypes.NONE
		Session.Views.PVAI:
			setup_PVAI()
			_pong.ai_type = _pong.AiTypes.NONE
			_ping.ai_type = _ping.AiTypes.QLEARNING
		Session.Views.AIVP:
			setup_AIVP()
			_pong.ai_type = _pong.AiTypes.QLEARNING
			_ping.ai_type = _ping.AiTypes.QLEARNING
		Session.Views.AIVAIP:
			setup_AIVAI()
			_pong.ai_type = _pong.AiTypes.QLEARNING
			_ping.ai_type = _ping.AiTypes.QLEARNING_PLUS


## Private Methods
func _remove_AIs() -> void:
	if _q_learning:
		get_parent().remove_child(_q_learning)

## Public Methods
func set_pong(new_value : NodePath) -> void:
	pong = new_value
	
	if is_inside_tree() and not pong.is_empty():
		_pong = get_node(pong)


func set_ping(new_value : NodePath) -> void:
	ping = new_value
	
	if is_inside_tree() and not ping.is_empty():
		_ping = get_node(ping)

func setup_PVP() -> void:
	pass

func setup_PVAI() -> void:
	_q_learning = QLearning.instance()
	get_parent().add_child(_q_learning)
	_q_learning.ping_bot_running = true
	
func setup_AIVP() -> void:
	_q_learning = QLearning.instance()
	get_parent().add_child(_q_learning)
	_q_learning.pong_bot_running = true
	
func setup_AIVAI() -> void:
	_q_learning = QLearning.instance()
	get_parent().add_child(_q_learning)
	_q_learning.pong_bot_running = true
	_q_learning.ping_bot_running = true


func _on_Game_tree_exiting():
	_remove_AIs()
