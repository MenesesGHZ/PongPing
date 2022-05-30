class_name GameEnvironment
extends Node

onready var q_learning := get_parent()

var x_divisions = 992 / 16
var y_divisions = 568 / 8

func generate_state(agent) -> Array:
	"""
	Transform bullets positions and direction into a discrete format.
	Bullet ratio = 16px
	Position.x is a value between [0, 1024] -> [16, 1008] -> [0, 992]
	Position.y is a value between [0, 600] -> [16, 584] -> [0, 568]
	danger_direction -> [0, 1]
	enemie position y -> 24 
	N-Bullets = 2
	N-Enemies = 1
	Number of posible combinations = ((16*8*2) * N-Bullets) * (8 * N-Enemies)  = 4,096
	"""
	var state = []
	for player in get_tree().get_nodes_in_group("Players"):
		if player != agent.player:
			var position_state = agent.generate_position_state()
			if "-" in position_state or "+" in position_state:
				position_state.erase(0, 1)
			state.append(position_state)
	for bullet in get_tree().get_nodes_in_group("Bullets"):
		var danger_direction = 0
		if (bullet.linear_velocity.x > 0 and bullet.position.x <= agent.player.position.x):
			danger_direction = 1
		elif(bullet.linear_velocity.x < 0 and bullet.position.x >= agent.player.position.x):
			danger_direction = 1
		var discrete_position_x = abs(round((bullet.position.x - 32) / x_divisions))
		var discrete_position_y = abs(round((bullet.position.y - 32) / y_divisions))
		state.append_array([
			discrete_position_x,
			discrete_position_y,
			danger_direction,
		])
	return state




