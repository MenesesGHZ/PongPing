tool
extends KinematicBody2D
## Player Class



## Signals
signal died(this)



## Preloads
const Bullet = preload("res://src/game/bullet/bullet.tscn")



## Enums
enum PlayerStates {
	IDLE,
	DYING,
	RESPAWN,
}

enum PlayerTypes {
	PONG,
	PING,
}

enum AiTypes {
	NONE,
	QLEARNING,
	QLEARNING_PLUS,
}



## Exported Variables
export(PlayerTypes) var player_type := PlayerTypes.PONG setget set_player_type

export(AiTypes) var ai_type : int

export var move_speed := 500.0

export var rotation_speed := 10

export(int, 0, 100) var bullets := 3



## Public Variables
var died := false

var won := false

var shielded := false



## Private Variables
var _player_state : int = PlayerStates.IDLE setget _set_player_state

var _bullets := []



## OnReady Variables
onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")

onready var bullet_spawn : Position2D = get_node("BulletSpawn")



## Built-In Virtual Methods
func _ready() -> void:
	if Engine.editor_hint:
		return
	
	for i in range(bullets):
		var bullet = Bullet.instance()
		bullet.player_owner = self
		_bullets.append(bullet)


func _process(delta : float) -> void:
	if Engine.editor_hint or _player_state == PlayerStates.DYING:
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
	elif ai_type == AiTypes.QLEARNING:
		var _player_type := "pong" if player_type == PlayerTypes.PONG else "ping"
		controller(
			Input.is_action_pressed(_player_type + "_up"),
			Input.is_action_pressed(_player_type + "_down"),
			Input.is_action_pressed(_player_type + "_right"),
			Input.is_action_pressed(_player_type + "_left"),
			Input.is_action_just_released(_player_type + "_shoot")
		)
	elif ai_type == AiTypes.QLEARNING_PLUS:
		# TODO Add Q-learning+ logic
		pass
	
	if player_type == PlayerTypes.PONG:
		position.x = 128
	else:
		position.x = 896
	position.y = clamp(position.y, 80, 520)

func controller(up: bool, down: bool, rotate_right: bool, rotate_left: bool, shoot: bool):
	var direction := Vector2.ZERO
	if up:
		direction += Vector2.UP
	if down:
		direction += Vector2.DOWN
	if rotate_right:
		rotate(deg2rad(rotation_speed))
	if rotate_left:
		rotate(deg2rad(-rotation_speed))
	if shoot:
		shoot()
	direction = direction * move_speed
	move_and_slide(direction)

## Public Methods
func set_player_type(new_value : int) -> void:
	player_type = new_value
	match player_type:
		PlayerTypes.PONG:
			rotation = deg2rad(180)
		PlayerTypes.PING:
			rotation = deg2rad(0)


func can_shoot() -> bool:
	return _bullets.size() > 0


func shoot() -> void:
	if not can_shoot():
		return
	
	var bullet = _bullets.pop_front()
	get_parent().add_child(bullet)
	bullet.particles.set_amount(bullet.particles.amount)
	bullet.particles.set_emitting(true)
	bullet.global_position = bullet_spawn.global_position
	var impulse = bullet.compute_impulse(rotation_degrees)
	bullet.particles.direction = impulse * -1
	bullet.apply_impulse(Vector2(0, 0), impulse)


func hit() -> void:
	if _player_state == PlayerStates.DYING:
		return
	_set_player_state(PlayerStates.DYING)
	emit_signal("died", self)
	died = true


## Private Methods
func _set_player_state(new_value : int) -> void:
	_player_state = new_value
	match _player_state:
		PlayerStates.IDLE:
			animation_player.play("RESET")
		PlayerStates.DYING:
			animation_player.play("die")
			yield(animation_player, "animation_finished")
			_set_player_state(PlayerStates.RESPAWN)
		PlayerStates.RESPAWN:
			animation_player.play("respawn")
			yield(animation_player, "animation_finished")
			_set_player_state(PlayerStates.IDLE)
