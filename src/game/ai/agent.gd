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

func generate_state() -> Array:
	var state = [
		player.position.x,
		player.position.y,
		player.rotation,
		player._bullets.size(),
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
	
func valid_sequence() -> bool:
	return null in sequence

func _process(delta: float):
	pass

func _ready():
	pass


