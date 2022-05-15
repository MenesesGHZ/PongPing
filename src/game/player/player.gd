tool
extends KinematicBody2D
## Player Class



## Enums
enum PlayerTypes {
	PONG,
	PING,
}

enum AiTypes {
	NONE,
}



## Exported Variables
export(PlayerTypes) var player_type := PlayerTypes.PONG setget set_player_type

export(AiTypes) var ai_type := AiTypes.NONE

export var move_speed := 500.0

export var rotation_speed := 10



## Private Variables
var _bullets := []



## Built-In Virtual Methods
func _ready() -> void:
	if Engine.editor_hint:
		return
	
	for i in range(3):
		# TODO Spawn Bullet
		pass


func _process(delta : float) -> void:
	if Engine.editor_hint:
		return
	
	var direction := Vector2.ZERO
	
	if ai_type == AiTypes.NONE:
		var _player_type := "pong" if player_type == PlayerTypes.PONG else "ping"
		
		if Input.is_action_pressed(_player_type + "_up"):
			direction += Vector2.UP
		if Input.is_action_pressed(_player_type + "_down"):
			direction += Vector2.DOWN
		
		if Input.is_action_pressed(_player_type + "_right"):
			rotate(deg2rad(rotation_speed))
		if Input.is_action_pressed(_player_type + "_left"):
			rotate(deg2rad(-rotation_speed))
		
		if Input.is_action_just_released(_player_type + "_shoot"):
			shoot()
	
	direction = direction * move_speed
	
	move_and_slide(direction)



## Public Methods
func set_player_type(new_value : int) -> void:
	player_type = new_value
	match player_type:
		PlayerTypes.PONG:
			rotation_degrees = 0
		PlayerTypes.PING:
			rotation_degrees = -180


func can_shoot() -> bool:
	return _bullets.size() > 0


func shoot() -> void:
	if not can_shoot():
		return
	
	# TODO Spawn Bullet
