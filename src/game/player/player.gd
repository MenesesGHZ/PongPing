extends KinematicBody2D
## Player Class



## Exported Variables
export var speed := 500



## Built-In Virtual Methods
func _process(delta : float) -> void:
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("player_up"):
		direction += Vector2.UP
	if Input.is_action_pressed("player_right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("player_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("player_left"):
		direction += Vector2.LEFT
	
	print(direction)
	
	move_and_collide(direction.normalized() * speed * delta)
