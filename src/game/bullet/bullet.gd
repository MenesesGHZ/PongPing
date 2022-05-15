extends RigidBody2D

var initial_impulse = 700
var bounce_counter = 0
var player_owner
onready var particles = get_node("CPUParticles2D")

func _ready():
	pass

func _process(_delta: float) -> void:
	pass

func _on_body_entered(body):
	var core_hitted = body.has_node("CollisionShape2D")
	if core_hitted and body.is_in_group("Players"):
		body.set_life_points(1)
	
	
func _on_body_exited(body):
	bounce_counter += 1

	if bounce_counter == 3:
		get_parent().remove_child(self)
		particles.set_amount(particles.amount)
		particles.set_emitting(false)
		player_owner._bullets.append(self)
		linear_velocity = Vector2(0, 0)
		rotation_degrees = 0
		bounce_counter = 0
		
func compute_impulse(rotation_degrees: float) -> Vector2:
	var radians = rotation_degrees * PI/180
	var impulse = Vector2(cos(radians), sin(radians))
	return initial_impulse * impulse
