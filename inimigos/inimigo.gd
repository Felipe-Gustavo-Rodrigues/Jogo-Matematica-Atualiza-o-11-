extends CharacterBody2D
class_name Enemy


var _loading_dash:bool=false
var _is_dash: bool=false
var _posicion_anterior:Vector2
var _coins: Dictionary={
	"coin":{
		"spawn_prob": 0.8,
		"scene_path":preload("res://acessorios/coin.tscn")
	},
	"diamante":{
		"spawn_prob": 0.2,
		"scene_path":preload("res://acessorios/diamont.tscn")
	}
	
}
var TEXT_POPUP:PackedScene = preload("res://interface/text_popup.tscn")
var _EXPLOSAO:PackedScene = preload("res://particulas/Particula_exVermelho.tscn")

@export_category("Variables")
@export var _enemy_type:String ="chase"
@export var _move_speed: float = 192.0
@export var _dash_speed:float = 768.0
@export var _damage: int
@warning_ignore("unused_private_class_variable")
@export var _invincibility_cooldoon: float = 0.5
@export var _health:int = 15


@export_category("Objetos")
@export var _hitbox_are: Area2D
@export var _dash_wait_time :Timer
@export var _dash_timer:Timer
@export var _invencibili_timer:Timer
@export var _auxiliar_animation: AnimationPlayer
@export var anim_sprite:AnimatedSprite2D 

func _physics_process(_delta: float) -> void:
	if _loading_dash:
		return
		
	if globall.player == null:
		return
		
	var _direction:Vector2 = global_position.direction_to(globall.player.global_position)
	var _distancia: float = global_position.distance_to(globall.player.global_position)
	if _distancia <= 16.0:
		
		return
	match _enemy_type:
		"chase":
			_chase(_direction)
		"chase_and_dash":
			_chase_and_dash(_direction)
			
	move_and_slide()
func _chase(_direction:Vector2) -> void:
	velocity = _direction * _move_speed
	animação_andar(_direction)

func _chase_and_dash(_direction: Vector2) -> void:
	var _direction_uso: Vector2
	if not _is_dash:
		velocity = _direction * _move_speed
		_direction_uso = _direction
	else:
		var _dash_direction = global_position.direction_to(_posicion_anterior)
		velocity = _dash_direction * _dash_speed
		_direction_uso = _dash_direction  
		# Verifica se o inimigo terminou o dash, e se sim, volta à perseguição
	if global_position.distance_to(_posicion_anterior) <= 10.0:  # O valor 10.0 pode ser ajustado
		_is_dash = false  # Reseta o estado do dash
		_posicion_anterior = global_position  # Atualiza a posição anterior para evitar movimento errático
		velocity = _direction * _move_speed  # Retorna ao comportamento de perseguição
	animação_andar(_direction_uso)

		
func animação_andar(_direcao:Vector2)-> void:
	if abs(_direcao.x) > abs(_direcao.y):
		if _direcao.x > 0:
			if anim_sprite.animation != "esquerda":
				anim_sprite.play("esquerda")
				anim_sprite.flip_h=false
		else:
			if anim_sprite.animation != "esquerda":
				anim_sprite.play("esquerda")
				anim_sprite.flip_h=true
	else:
		if _direcao.y > 0:
			if anim_sprite.animation != "frente":
				anim_sprite.play("frente")
				anim_sprite.flip_h=false
		else:
			if anim_sprite.animation != "tras":
				anim_sprite.play("tras")
				anim_sprite.flip_h=false


func update_health(_value: int) -> void:
	_health -= _value
	globall.damage += _value
	_auxiliar_animation.play("hit")
	if _health <= 0:
		get_tree().call_group("play_camera", "shack", 2.0, 0.3)
		_spawn_coins()
		globall.enemy_kills += 1
		_spawn_explosion_particles()
		queue_free()
		return
	_spawn_text_popup(_value)
	
	get_tree().call_group("play_camera", "shack", 1.0, 0.3)
	
func _spawn_coins()->void:
	for _coin in _coins:
		var _randf : float=randf()
		if _randf <= _coins[_coin]["spawn_prob"]:
			var _coin_scene: Coin = _coins[_coin]["scene_path"].instantiate()
			get_tree().root.call_deferred("add_child", _coin_scene)
			_coin_scene.global_position = global_position
			
func _spawn_text_popup(_value:int)->void:
	var _popup: TextPop = TEXT_POPUP.instantiate()
	_popup.ulpdate_text(_value)
	_popup.global_position=global_position
	get_tree().root.call_deferred("add_child", _popup)
	
func _spawn_explosion_particles() -> void:
	if globall.is_changing_scene:
		return
	var _particles: CPUParticles2D = _EXPLOSAO.instantiate()
	_particles.global_position = global_position
	_particles.emitting = true
	get_tree().root.call_deferred("add_child", _particles)

func _on_area_aucance_body_entered(_body: Node2D) -> void:
	if _is_dash:
		return
		
	if _enemy_type != "chase_and_dash":
		return
	if _body is Jogador:
		_posicion_anterior = globall.player.global_position
		_dash_wait_time.start()
		_loading_dash=true


func _on_dash_tempo_timeout() -> void:
	_loading_dash=false
	_is_dash=true
	_dash_timer.start()


func _on_dash_timer_timeout() -> void:
	_is_dash = false
	_posicion_anterior = global_position

func _on_heatbox_area_body_entered(_body: Node2D) -> void:
	if _body is Jogador:
		_hitbox_are.set_deferred("monitorable", false)
		_invencibili_timer.start()
		_body.update_health("damage", _damage)


func _on_invencibili_timer_timeout() -> void:
	_hitbox_are.set_deferred("monitorable", false)
	
