class_name Agent
extends Node

var player

onready var q_learning := get_parent()

var policy = {}
var sequence = [
	null, # state 1 
	null, # action 1
	null, # reward 2
	null, # state 2
	null, # action 2
]
var actions = [
	"up",
	"down",
	"rotate_right",
	"rotate_left",
	"shoot",
	"none"
]

var past_discrete_rotation
var past_discrete_position

func generate_state() -> Array:
	var state = [
		generate_position_state(),
		generate_rotation_state(),
		int(player.can_shoot()),
		int(player.ai_flag_shielded),
		int(player.ai_flag_died),
		int(player.ai_flag_won),
	]
	return state
	
func reset_ai_flags() -> void:
	player.ai_flag_shielded = false
	player.ai_flag_died = false
	player.ai_flag_won = false
	
func pick_random_action(state: Array) -> String:
	var valid_actions = ["none"] 
	if not state[0][0] in ["-", "+"]:
		valid_actions.append(actions[0])
		valid_actions.append(actions[1])
	if not state[1][0] in ["-", "+"]:
		valid_actions.append(actions[2])
		valid_actions.append(actions[3])
	if state[2] == 1:
		valid_actions.append(actions[4])
	return valid_actions[randi() % valid_actions.size()]
	
func generate_rotation_state() -> String:
	"""
	Generates a state base on player.rotation_degrees.
	Where rotation_degrees is a value between [-180, 180] -> [0, 360].
	"""
	var current_rotation = fmod(player.rotation_degrees + 180, 360)
	var current_discrete_rotation = current_rotation / 45
	var diff = abs(current_discrete_rotation - past_discrete_rotation)
	if 0.05 < diff and diff < 0.95:
		var direction
		if current_discrete_rotation > past_discrete_rotation:
			direction = "+"
		else:
			direction = "-"
		return direction + str(abs(past_discrete_rotation))  
	past_discrete_rotation = round(current_discrete_rotation)
	return str(past_discrete_rotation)
	
func generate_position_state() -> String:
	"""
	Generates a state base on player.position.y.
	Where position.y is a value between [80, 520] -> [0, 440]
	"""
	var current_position = player.position.y - 80  # offset due to player-board boundories
	var current_discrete_position = current_position / 88
	var diff = abs(current_discrete_position - past_discrete_position)
	if 0.05 < diff and diff < 0.95:
		var direction
		if current_discrete_position > past_discrete_position:
			direction = "+"
		else:
			direction = "-"
		return direction + str(past_discrete_position)
	past_discrete_position = abs(round(current_discrete_position))
	return str(past_discrete_position)
	
func update_sequence(state: Array, action: String):
	sequence[0] = sequence[3]
	sequence[1] = sequence[4]
	sequence[2] = q_learning.compute_reward(state)
	sequence[3] = q_learning.parse_state(state)
	sequence[4] = action

func valid_sequence() -> bool:
	return sequence[0] != null and sequence[1] != null

func do_action(action: String, state: Array):
	player.controller(
		(action == actions[0] || state[0][0] == "-"),
		(action == actions[1] || state[0][0] == "+"),
		(action == actions[2] || state[1][0] == "+"),
		(action == actions[3] || state[1][0] == "-"),
		action == actions[4]
	)

func init():
	past_discrete_rotation = round(fmod(player.rotation_degrees + 180, 360) / 45)
	past_discrete_position = round((player.position.y - 80) / 88)
