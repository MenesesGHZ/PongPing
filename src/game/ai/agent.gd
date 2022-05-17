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
	null  # reward 3
]
var actions = [
	"up",
	"down",
	"rotate_positive",
	"rotate_negative",
	"shoot"
]

var past_discrete_rotation
var past_discrete_position

func generate_state() -> Array:
	var state = [
		generate_position_state(),
		generate_rotation_state(),
		player._bullets.size() > 0,
		int(player.shielded),
		int(player.died),
		int(player.won)
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
		return direction + past_discrete_rotation  
	past_discrete_rotation = str(round(current_discrete_rotation))
	return past_discrete_rotation
	
func generate_position_state() -> String:
	var current_position = player.position.y - 80  # offset due to player-board boundories
	var current_discrete_position = current_position / 33.84615
	if current_discrete_position > 0.05:
		var direction
		if (current_discrete_position - past_discrete_position) > 0:
			direction = "+"
		else:
			direction = "-"
		return direction + past_discrete_position
	past_discrete_position = str(round(current_discrete_position))
	return past_discrete_position
	
func valid_sequence() -> bool:
	return null in sequence

func _process(delta: float):
	pass

func _ready():
	pass


