class_name Agent
extends Node

var player

onready var q_learning := get_parent()

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
	

func _process(delta: float):
	pass

func _ready():
	pass


