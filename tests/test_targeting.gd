extends "res://addons/gut/test.gd"

var archer
var scene_instance

func before_each():
	# Instancia a cena principal (background com o archer) diretamente na raiz
	var scene = load("res://scenes/background.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene_instance = scene

	archer = scene_instance.get_node("Archer")
	archer.global_position = Vector2.ZERO

func after_each():
	# Limpa a cena após cada teste
	scene_instance.queue_free()
	scene_instance = null
	archer = null

# Função auxiliar para spawnar inimigos
func _spawn_enemy(name: String, pos: Vector2) -> Node2D:
	var e = Node2D.new()
	e.name = name
	e.global_position = pos
	e.add_to_group("enemy")
	get_tree().root.add_child(e)
	return e

func test_selects_nearest_enemy():
	# Cria inimigos
	var e_far = _spawn_enemy("E_far", Vector2(10, 0))
	var e_near = _spawn_enemy("E_near", Vector2(2, 0))
	
	# Adiciona manualmente os inimigos ao detector do archer
	var detector = archer.get_node("EnemyDetectArea")
	detector.enemy_in_area = [e_far, e_near]
	
	# Força atualização do alvo
	archer.update_target()
	
	# Espera um frame para garantir que _physics_process rodou
	await get_tree().process_frame
	
	assert_true(archer.current_target != null, "Deveria ter selecionado um alvo")
	assert_eq(archer.current_target.name, "E_near", "Deve escolher o inimigo mais próximo")

func test_ignores_outside_radius():
	var e_out = _spawn_enemy("E_out", Vector2(100, 0)) # inimigo fora da área

	# Não adiciona manualmente ao enemy_in_area
	archer.update_target()
	await get_tree().process_frame

	assert_true(archer.current_target == null, "Não deve selecionar inimigos fora da área")
