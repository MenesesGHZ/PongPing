class_name QLearning
extends Node


onready var agent_pong := get_node("AgentPong")
onready var agent_ping := get_node("AgentPing")
onready var environment := get_node("Environment")

var pong_bot_running = false
var ping_bot_running = false

var e = 0.025 # Explorative -> 0.25;  Greedy -> 0.025
var alpha = 0.15
var gamma = 0.5

var metadata = {
	"global": {
		"iteration_counter": 0,
		"matches_counter": 0,
		"total_number_of_states": 6144 * 12800,
	},
	"pong": {
		"iteration_counter_without_die": 0,
		"win_counter_without_die": 0,
		"shielded_counter_without_die": 0,
		"hit_counter_without_die": 0,
		"win_counter": 0,
		"lose_counter": 0,
	},
	"ping": {
		"iteration_counter_without_die": 0,
		"win_counter_without_die": 0,
		"shielded_counter_without_die": 0,
		"hit_counter_without_die": 0,
		"win_counter": 0,
		"lose_counter": 0,
	}
}

var stuck_counter = 0 # ERROR VAR

func _ready():
	agent_pong.player = get_tree().root.find_node("Pong", true, false)
	var metadata_pong = agent_pong.init(1321)
	metadata["global"] = metadata_pong[0]
	metadata["pong"] = metadata_pong[1]
	
	agent_ping.player = get_tree().root.find_node("Ping", true, false)
	var metadata_ping = agent_ping.init(1222)
	metadata["global"] = metadata_ping[0]
	metadata["ping"] = metadata_ping[1]

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
		agent.policy[s_0][a_0] += alpha * (r_1 + gamma * max_q_sa - q_sa)

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
	
	if (not agent_pong.did_change(agent_pong_state) and 
		not agent_ping.did_change(agent_ping_state)) and stuck_counter <= 2:
		stuck_counter += 1
		return

	stuck_counter = 0
	
	if pong_bot_running:
		var agent_pong_action = Q(agent_pong, agent_pong_state)
		agent_pong.do_action(agent_pong_action, agent_pong_state)
	
	if ping_bot_running:
		var agent_ping_action = Q(agent_ping, agent_ping_state)
		agent_ping.do_action(agent_ping_action, agent_ping_state)
	
	#update_metadata(agent_pong_state, agent_ping_state)
	
	agent_pong.reset_ai_flags()
	agent_ping.reset_ai_flags()
	
func compute_reward(agent, state: Array):
	if state[5]: # if won
		return 10
	if state[4]: # if died
		return -10
	if state[3]: # if shielded
		return 3
	if agent.player.ai_flag_hit:
		return 3
	return -2  # if lazy

func generate_state(agent):
	"""
	Total number of combinations = agent states combs * environment states combs
	T = 6,144 * 512 = 3,145,728
	"""
	var state = []
	state.append_array(agent.generate_state())
	state.append_array(environment.generate_state(agent))
	return state 
	
func update_metadata(state_1: Array, state_2: Array):
	metadata["global"]["iteration_counter"] += 1
	metadata["pong"]["iteration_counter_without_die"] += 1
	metadata["ping"]["iteration_counter_without_die"] += 1
	metadata["pong"]["shielded_counter_without_die"] += int(agent_pong.player.ai_flag_shielded)
	metadata["ping"]["shielded_counter_without_die"] += int(agent_ping.player.ai_flag_shielded)
	metadata["pong"]["hit_counter_without_die"] += int(agent_pong.player.ai_flag_hit)
	metadata["ping"]["hit_counter_without_die"] += int(agent_ping.player.ai_flag_hit)
	if state_1[4] and pong_bot_running:
		metadata["pong"]["lose_counter"] += 1
		metadata["ping"]["win_counter"] += 1
		metadata["ping"]["win_counter_without_die"] += 1
		metadata["global"]["matches_counter"] += 1
		agent_pong.save_brain(metadata["global"], metadata["pong"])
		metadata["pong"]["iteration_counter_without_die"] = 0
		metadata["pong"]["win_counter_without_die"] = 0
		metadata["pong"]["shielded_counter_without_die"] = 0
		metadata["pong"]["hit_counter_without_die"] = 0
	if state_2[4] and ping_bot_running:
		metadata["ping"]["lose_counter"] += 1
		metadata["pong"]["win_counter"] += 1
		metadata["pong"]["win_counter_without_die"] += 1
		metadata["global"]["matches_counter"] += 1
		agent_ping.save_brain(metadata["global"], metadata["ping"])
		metadata["ping"]["iteration_counter_without_die"] = 0
		metadata["ping"]["win_counter_without_die"] = 0
		metadata["ping"]["shielded_counter_without_die"] = 0
		metadata["ping"]["hit_counter_without_die"] = 0
