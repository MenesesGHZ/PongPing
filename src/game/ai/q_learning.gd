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
	var q_sa 
	var max_q_sa
	var action
	var value
	if not s_t in agent.policy: 
		agent.policy[s_t] = {}
		action = agent.pick_random_action()
		agent.policy[s_t][action] = randi() % 10
	
	value = argmax_Q_sa(agent, state)
	max_q_sa = value[0]
	action = value[1]
	if randf() > e:
		action = agent.pick_random_action()
		
	q_sa = agent.policy[agent.sequence[0]][agent.sequence[1]]
	agent.policy[agent.sequence[0]] \
				[agent.sequence[1]] += \
				alpha * (agent.sequence[2] + max_q_sa - q_sa)
				
	agent.sequence[0] = agent.sequence[3]
	agent.sequence[1] = agent.sequence[4]
	agent.sequence[2] = agent.sequence[5]
	agent.sequence[3] = state
	agent.sequence[4] = action
	agent.sequence[5] = ""
	return action
	
func argmax_Q_sa(agent, state : String) -> Array:
	var max_qs = -1000
	var max_action = agent
	for action in agent.policy[state]:
		if agent.policy[state][action] > max_qs:
			max_qs = agent.policy[state][action]
			max_action = action
	return [max_qs, max_action]
	
	
func parse_state(state: Array) -> String:
	var ss = ""
	for s in state:
		ss += str(s)
	return ss
	
func _process(delta):
	return
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
