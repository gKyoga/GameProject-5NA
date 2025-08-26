extends CharacterBody2D

var spd = 600
var dir = Vector2()

var rotating = false
var rotation_speed = 700 
var rotated = 0.0

const dash_speed = 900 
var dashing = false


func _process(delta: float) -> void:
	if rotating:
		var step = rotation_speed * delta
		$AnimatedSprite2D.rotation_degrees += step
		rotated += step
		if rotated >= 360:
			rotating = false
			rotated = 0.0
			$AnimatedSprite2D.rotation_degrees = 0
	pass


func _physics_process(delta: float) -> void:
	MovePlayer(delta)
	pass

func MovePlayer(delta):
	dir = Vector2()

	if Input.is_action_pressed("Up"):
		dir += Vector2.UP
	if Input.is_action_pressed("Down"):
		dir += Vector2.DOWN
	if Input.is_action_pressed("Left"):
		dir += Vector2.LEFT
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed("Right"):
		dir += Vector2.RIGHT
		$AnimatedSprite2D.flip_h = false

	if Input.is_action_just_pressed("Dash") and not dashing:
		start_rotation() 
		dashing = true
		await get_tree().create_timer(0.2).timeout
		dashing = false

	if dir != Vector2.ZERO:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("stop")

	if dashing:
		global_position += dir.normalized() * dash_speed * delta
	else:
		global_position += dir.normalized() * spd * delta


func start_rotation():
	rotating = true
	rotated = 0.0
