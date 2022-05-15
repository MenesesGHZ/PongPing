extends RigidBody2D

var bounce_counter = 0
var player_owner

func _ready():
	apply_impulse(Vector2(0,0), Vector2(500, 0))

func _process(_delta: float) -> void:
	pass

func _on_body_exited(body):
	bounce_counter+=1
	if bounce_counter == 3:
		get_parent().remove_child(self)
		player_owner._bullets.append(self)
		bounce_counter = 0
