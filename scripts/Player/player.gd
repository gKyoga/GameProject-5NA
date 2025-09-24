extends CharacterBody2D

class_name Player

#status base
var Level = 1
var Hp = 100
var Spd = 300
var Xp = 0

#variaveis de movimentação
var dir = Vector2()


func _process(delta: float) -> void:	
	pass
	
func _physics_process(delta: float) -> void:
	MovePlayer(delta)
	pass

#movimentação
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
		
	if dir != Vector2.ZERO:
		$AnimatedSprite2D.play("Walk")
	else:
		$AnimatedSprite2D.play("Idle")
	
	global_position += dir.normalized() * Spd * delta

#calcula xp necessaria para upar de nivel
func CalcExpLevel(Level):
	return 20 * Level * Level

#calcula o xp total para subir de nivel
func CalcExpNextLevel(Xp):
	var required = CalcExpLevel(Level)
	return max(required - Xp, 0)

func LevelUp():
	if Xp >= CalcExpLevel(Level + 1):
		Level += 1
