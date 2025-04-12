extends Node2D
class_name Inimigo_Spawn 

const INIMIGO_1: PackedScene = preload("res://inimigos/Inimigo_verde_1.tscn")
const INIMIGO_2: PackedScene = preload("res://inimigos/inimigos_2.tscn")
const INIMIGO_3: PackedScene = preload("res://inimigos/inimigos_roxos_3.tscn")

var _waves_dict: Dictionary = {
	1: {
		"inimi_time": 6,
		"inimi_spaw_coodown": 4,
		"inimi_numero": 1,
		"spots_amount": [5, 8],
		"inimi_dificult": "ease"
	},
	2: {
		"inimi_time": 10,
		"inimi_spaw_coodown": 4,
		"inimi_numero": 1,
		"spots_amount": [5, 8],
		"inimi_dificult": "medium"
	},
	3:{
		"inimi_time": 10,
		"inimi_spaw_coodown": 4,
		"inimi_numero": 1,
		"spots_amount": [5, 8],
		"inimi_dificult": "medium"
	},
	4:{
		"inimi_time": 15,
		"inimi_spaw_coodown": 5,
		"inimi_numero": 2,
		"spots_amount": [5, 8],
		"inimi_dificult": "medium_to_hard"
	},
	5:{
		"inimi_time": 30,
		"inimi_spaw_coodown": 2,
		"inimi_numero": 1,
		"spots_amount": [4, 7],
		"inimi_dificult": "hard"
	}
	
}

var _current_wave: int = 1
@export_category("Variebles")
@export var posicion_initial: Vector2 = Vector2(100, 100)

@export_category("Objetos") 
@export var _inimigo_timer: Timer
@export var _inimigo_spawn_cooldown: Timer
@export var interface: CanvasLayer = null
@export var player: Jogador = null

func _ready() -> void:
	globall.inimigo_spawn=self
	globall.reset_statisc()
	interface.update_wave_and_time_label(_current_wave, _inimigo_timer.time_left-1)
	_inimigo_timer.start(_waves_dict[_current_wave]["inimi_time"])
	_inimigo_spawn_cooldown.start(_waves_dict[_current_wave]["inimi_spaw_coodown"])
	_spawn_inimigos()

func _on_inimigo_timer_timeout() -> void:
	
	_current_wave += 1
	print("🌊 Iniciando nova onda:", _current_wave)
	if _current_wave > _waves_dict.size():
		get_tree().change_scene_to_file("res://interface/after_game.tscn")
		return
		
	clear_map()
		
	if _current_wave >= 2:
			globall.interface.colocar_questões(false,true)
			
	else:
		start_new_wave()
	_inimigo_timer.start(_waves_dict[_current_wave]["inimi_time"])
	_inimigo_spawn_cooldown.start(_waves_dict[_current_wave]["inimi_spaw_coodown"])
	_spawn_inimigos()
	return
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/wave_success.ogg")
	clear_map()

func _on_inimigo_spawn_cooldown_timeout() -> void:
	if _waves_dict.has(_current_wave):
		return
	_spawn_inimigos()
	_inimigo_spawn_cooldown.stop()
	_inimigo_spawn_cooldown.start(_waves_dict[_current_wave]["inimi_spaw_coodown"])

func _spawn_inimigos() -> void:

	if _current_wave in _waves_dict:
		var _amount_range: Array = _waves_dict[_current_wave]["spots_amount"]
		var _amount: int = randi_range(_amount_range[0], _amount_range[1])
		
		var _spots: Array = []

		for _children in get_children():
			if not _children is Timer:
				_spots.append(_children)
		
		var _spown_spots: Array=[]
		for _i in _amount:
			if _spots.size() == 0: 
				break
			var index:int = randi() % max(1, _spots.size())
			var select_spots:Node2D = _spots[index]
			_spown_spots.append(select_spots)
			_spots.remove_at(index)
		for _spot in _spown_spots:
			var _childrens: Array =[]
			var select_childrens: Array = []
			for _children in _spot.get_children():
				_childrens.append(_children)
			var amount_list: Array = _waves_dict[_current_wave]["spots_amount"]
			var select_amount: int = randi_range(amount_list[0], amount_list[1])
			for _i in select_amount:
				var index: int = randi() % _childrens.size()
				var select_spot: Node2D = _childrens[index]
				select_childrens.append(select_spot)
				_childrens.remove_at(index)
			
			for _spawner in select_childrens:
				_spawn_inimigo(_spawner)
				
func _spawn_inimigo(_spawer: Node2D) ->void:
	var inimigo: Enemy = null
	var _randf : float = randf()
	var _dificuldade: String = _waves_dict[_current_wave]["inimi_dificult"]
	match _dificuldade:
		"ease":
			inimigo = INIMIGO_1.instantiate()
		"ease_to_medium":
			if _randf <= 0.7:
				inimigo = INIMIGO_1.instantiate()
			else:
				inimigo = INIMIGO_2.instantiate()
		"medium":
			if _randf <= 0.5:
				inimigo = INIMIGO_1.instantiate()
			else:
				inimigo = INIMIGO_2.instantiate()
		"medium_to_hard":
			if _randf <= 0.4:
				inimigo = INIMIGO_1.instantiate()
			elif _randf  > 0.4 and _randf <=0.9:
				inimigo = INIMIGO_2.instantiate()
			else:
				inimigo = INIMIGO_3.instantiate()
		"hard":
			if _randf <= 0.2:
				inimigo = INIMIGO_1.instantiate()
			elif _randf >0.2 and _randf<=0.7:
				inimigo = INIMIGO_2.instantiate()
			else:
				inimigo = INIMIGO_3.instantiate()
	inimigo.global_position=_spawer.global_position
	get_parent().call_deferred("add_child", inimigo)
	
func _on_curent_timer_timer_timeout() -> void:
	globall.time_alive+=1
	interface.update_wave_and_time_label(_current_wave, _inimigo_timer.time_left)

func clear_map(_can_kill_player:bool = false)->void:
	print("⏳ Timer acabou, limpando mapa...", interface)
	for _chidren in get_tree().get_nodes_in_group("text_popup"):
		_chidren.queue_free()
	for _chidren in get_tree().get_nodes_in_group("particles"):
		_chidren.queue_free()
	for _chidren in get_tree().get_nodes_in_group("arrows"):
		_chidren.queue_free()
	for _children in get_tree().get_nodes_in_group("coins"):
		_children.queue_free()
	for _children in get_parent().get_children():
		
		if _children is Enemy:
			_children._hitbox_are.set_deferred("monitoring", false)
			_children.queue_free()
			get_tree().call_group("play_camera", "reset_shake")
	await get_tree().create_timer(0.1).timeout
	
	if _can_kill_player:
		get_tree().call_group("Espada-pequena", "queue_free")
		get_tree().call_group("Lanca", "queue_free")
		get_tree().call_group("Arco", "queue_free")
		globall.is_changing_scene = true
		for anim_player in get_tree().get_nodes_in_group("animation_players"):
			anim_player.stop()
		get_tree().change_scene_to_file("res://interface/after_game.tscn")
		player.queue_free()
		return
	

func start_new_wave() -> void:
	_inimigo_timer.start(_waves_dict[_current_wave]["inimi_time"])
	player.global_position = posicion_initial
