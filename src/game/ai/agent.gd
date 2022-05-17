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
	"shoot"
]

var past_discrete_rotation
var past_discrete_position

func generate_state() -> Array:
	var state = [
		generate_position_state(),
		generate_rotation_state(),
		int(player.can_shoot()),
		int(player.shielded),
		int(player.died),
		int(player.won),
	]
	player.shielded = false
	player.died = false
	player.won = false
	return state
	
func pick_random_action() -> String:
	return actions[randi() % actions.size()]
	
func generate_rotation_state() -> String:
	var current_rotation = rad2deg(player.get_rotation())
	var current_discrete_rotation = current_rotation / 22.5
	if abs(current_discrete_rotation) > 0.05:
		var direction
		if 0 <= current_discrete_rotation and current_discrete_rotation <= 8:
			if past_discrete_rotation < current_discrete_rotation:
				direction = "+"
			else:
				direction = "-"
		elif 0 >= current_discrete_rotation and current_discrete_rotation >= -8:
			if past_discrete_rotation > current_discrete_rotation:
				direction = "+"
			else:
				direction = "-"
		else:
			assert(true, "ALV!!!! WHY [%s : %s]" % [current_discrete_rotation, past_discrete_rotation])
		return direction + str(past_discrete_rotation)  
	past_discrete_rotation = round(current_discrete_rotation)
	return str(past_discrete_rotation)
	
func generate_position_state() -> String:
	var current_position = player.position.y - 80  # offset due to player-board boundories
	var current_discrete_position = current_position / 33.84615
	if current_discrete_position > 0.05:
		var direction
		if (current_discrete_position - past_discrete_position) > 0:
			direction = "+"
		else:
			direction = "-"
		return direction + str(past_discrete_position)
	past_discrete_position = round(current_discrete_position)
	return str(past_discrete_position)
	
func update_sequence(state: Array, action: String):
	sequence[0] = sequence[3]
	sequence[1] = sequence[4]
	sequence[2] = q_learning.compute_reward(state)
	sequence[3] = q_learning.parse_state(state)
	sequence[4] = action

func valid_sequence() -> bool:
	return sequence[0] != null and sequence[1] != null

func do_action(action: String):
	player.controller(
		action == actions[0],
		action == actions[1],
		action == actions[2],
		action == actions[3],
		action == actions[4]
	)

func init():
	past_discrete_rotation = round(rad2deg(player.get_rotation()) / 22.5)
	past_discrete_position = round(player.position.y - 80 / 33.84615)
