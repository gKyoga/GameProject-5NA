extends CharacterBody2D

@export var speed: float = 100.0
var player: Node2D = null

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D


#encontrar o jogador na cena!!
func _ready():
	player = get_tree().get_first_node_in_group("Player")


func _process(delta: float) -> void:
	
	pass


func _physics_process(delta: float) -> void:
	if player and is_instance_valid(player):
		var direction = (player.global_position - global_position).normalized()
		if direction.length() > 0.1:
			if Vector2.ZERO != direction:
				anim_sprite.play("Chase")
			if direction.x > 0:
				anim_sprite.flip_h = false
			elif direction.x < 0:
				anim_sprite.flip_h = true
			else:
				if anim_sprite.animation != "Idle":
					anim_sprite.play("Idle")
		
		
		
		velocity = direction * speed
		move_and_slide()
	
	
	pass
