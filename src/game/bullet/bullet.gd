extends RigidBody2D
## Bullet Class



## Exported Variables
export(float, 0, 1000) var initial_impulse := 700.0



## Public Variables
var player_owner : Node



## Private Variables
var _bounce_counter := 0



## OnReady Variables
onready var particles : CPUParticles2D = get_node("CPUParticles2D")



## Public Methods
func compute_impulse(rotation_degrees: float) -> Vector2:
	var radians = rotation_degrees * PI/180
	var impulse = Vector2(cos(radians), sin(radians))
	return initial_impulse * impulse

## Private Methods
func _on_body_entered(body : Node):
	var core_hitted = body.has_node("CollisionShape2D")
	if core_hitted and body.is_in_group("Players"):
		body.hit()
		if body != player_owner:
			player_owner.ai_flag_hit = true
			player_owner.ai_flag_won = true
		else:
			player_owner.ai_flag_died = true
	elif body.is_in_group("Shields"):
		if body != player_owner.get_node("StaticBody2D"):
			player_owner.ai_flag_hit = true
		body.get_parent().ai_flag_shielded = true
	

func _on_body_exited(body : Node):
	_bounce_counter += 1
	if _bounce_counter == 3:
		get_parent().remove_child(self)
		particles.set_amount(particles.amount)
		particles.set_emitting(false)
		player_owner._bullets.append(self)
		linear_velocity = Vector2(0, 0)
		rotation_degrees = 0
		_bounce_counter = 0
