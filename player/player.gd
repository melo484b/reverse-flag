extends KinematicBody2D


var velocity: Vector2 = Vector2.ZERO
export var speed: int = 200
export var jump_power: int = -1000
export var gravity: int = 3000
export var acceleration: float = 0.25
var direction: int = -1
var jumps: int = 2
var fatigued: bool = false

onready var flag = $flag
onready var fatigue_timer = $fatigue


func _ready() -> void:
	pass


func _physics_process(delta) -> void:
	get_input()
	game_movement()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func get_input() -> void:
	if Input.is_action_just_pressed("jump"):
		if jumps > 0:
			jumps -= 1
			velocity.y = jump_power
	if Input.is_action_just_pressed("reverse") and not fatigued:
		jumps = clamp(jumps + 1, 1, 2)
		velocity.x = 0
		direction *= -1
		flag.spin()
		fatigued = true
		fatigue_timer.start()


func game_movement() -> void:
	velocity.x = lerp(velocity.x, direction * speed, acceleration)


func _on_fatigue_timeout():
	fatigued = false
