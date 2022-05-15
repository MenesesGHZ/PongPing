class_name QLearning
extends Node


onready var agent_pong := get_node("AgentPong")
onready var agent_ping := get_node("AgentPing")
onready var environment := get_node("Environment")

func _ready():
	agent_pong.player = get_tree().root.find_node("Pong", true, false)
	agent_ping.player = get_tree().root.find_node("Ping", true, false)

var policy = {}

func Q():
	pass
	
func _process(delta):
	print(generate_state())	

func compute_reward():
	pass

func generate_state():
	var state = []
	state.append_array(agent_pong.generate_state())
	state.append_array(environment.generate_state(agent_pong))
	return state
