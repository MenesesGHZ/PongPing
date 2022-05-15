class_name QLearning
extends Node


onready var agent_pong := get_node("AgentPong")
onready var agent_ping := get_node("AgentPing")
onready var environment := get_node("Environment")

var e = 0.1
var alpha = 0.2
var gamma = 0.5

func _ready():
	agent_pong.player = get_tree().root.find_node("Pong", true, false)
	agent_ping.player = get_tree().root.find_node("Ping", true, false)


func Q(agent, state) -> String:
	var s_t = parse_state(state)
	if not s_t in agent.policy and randf() > e: 
		q_sa = randi() % 10 - 5
		agent.policy[s_t] = {}
		action = agent.actions[randi() % agent.actions.size()]
	else:
		value = argmax_Q_sa(agent, state)
		state = value[0]
		action = value[1]
	agent.policy[agent.sequence[0]] \
				[agent.sequence[1]] += \
				q_sa + alpha * (agent.sequence[2] + argmax_Q_sa(s_t) - q_sa)
	
	return action
	
func argmax_Q_sa(agent, state : String) -> Array:
	var max_qs = -1000
	var max_action = agent
	for action in player.policy[state]:
		if player.policy[state][action] > max_qs:
			max_qs = player.policy[state][action]
			max_action = action
	return [max_qs, max_action]
	
	
func parse_state(state: Array) -> String:
	ss = ""
	for s in state:
		ss += str(s)
	return ss
	
	
func _process(delta):
	var agent_pong_state = generate_state(agent_pong)
	var agent_ping_state = generate_state(agent_ping)
	var agent_pong_action = Q(agent_pong, agent_pong_state)
	var agent_ping_action = Q(agent_ping, agent_ping_state)


func compute_reward(state: Array):
	if(state[6]):
		return 10
	if(state[5]):
		return -10
	if(state[4]):
		return 1
	return -0.5 

func generate_state(agent):
	var state = []
	state.append_array(agent.generate_state())
	state.append_array(environment.generate_state(agent))
	return state
