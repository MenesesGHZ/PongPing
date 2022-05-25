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
	agent_pong.init()
	agent_ping.init()

func Q(agent, state) -> String:
	var s_t = parse_state(state)	

	if not s_t in agent.policy: 
		agent.policy[s_t] = {}
	
	var action
	var action_in_policy = action in agent.policy[s_t]
	if randf() > e or not action_in_policy:
		action = agent.pick_random_action(state)
		if not action_in_policy:
			agent.policy[s_t][action] = randi() % 10
	
	var value = argmax_Q_sa(agent, s_t)
	var max_q_sa = value[0]
	action = action if action else value[1]
	
	var s_0 = agent.sequence[0]
	var a_0 = agent.sequence[1]
	
	agent.update_sequence(state, action)
	var r_1 = agent.sequence[2]
	
	if s_0 != null and a_0 != null:
		var q_sa = agent.policy[s_0][a_0]
		agent.policy[s_0][a_0] += alpha * (r_1 + max_q_sa - q_sa)

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
	var agent_pong_state = generate_state(agent_pong)
	var agent_ping_state = generate_state(agent_ping)
	
	if (not (agent_pong_state[4] or agent_ping_state[4]) and 
		(agent_ping.player.is_dying() or agent_pong.player.is_dying())):
		return

	var agent_pong_action = Q(agent_pong, agent_pong_state)
	var agent_ping_action = Q(agent_ping, agent_ping_state)
	
	agent_pong.reset_ai_flags()
	agent_ping.reset_ai_flags()
	
	agent_pong.do_action(agent_pong_action, agent_pong_state)
	agent_ping.do_action(agent_ping_action, agent_ping_state)
	
func compute_reward(state: Array):
	if state[5]: # if won
		return 10
	if state[4]: # if died
		return -10
	if state[3]: # if shielded
		return 1
	return -0.5   # if lazy

func generate_state(agent):
	var state = []
	state.append_array(agent.generate_state())
	state.append_array(environment.generate_state(agent))
	return state
