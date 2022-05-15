class_name GameEnvironment
extends Node

onready var q_learning := get_parent()


func generate_state(agent) -> Array:
	var state = []
	var bullets = get_tree().get_nodes_in_group("Bullets")
	for bullet in bullets:
		var danger_direction = 0
		if (bullet.linear_velocity.x > 0 and bullet.position.x <= agent.player.position.x):
			danger_direction = 1
		elif(bullet.linear_velocity.x < 0 and bullet.position.x >= agent.player.position.x):
			danger_direction = 1
		state.append_array([
			bullet.position.x,
			bullet.position.y,
			danger_direction,
		])
	return state




