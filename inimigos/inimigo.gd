extends CharacterBody2D
class_name Enemy


var _loading_dash:bool=false
var _is_dash: bool=false
var _posicion_anterior:Vector2
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

func _chase_and_dash(_direction:Vector2) -> void:
	if not _is_dash:
		velocity=_direction*_move_speed
	if _is_dash:
		_direction = global_position.direction_to(_posicion_anterior)
		velocity=_direction*_dash_speed
		
		
func update_health(_value: int) -> void:
	_health -= _value
	_auxiliar_animation.play("hit")
	if _health <= 0:
		get_tree().call_group("play_camera", "shack", 6.0, 0.10)
		_spawn_explosion_particles()
		queue_free()
		return
		
	
	get_tree().call_group("play_camera", "shack", 3.0, 0.05)
	
func _spawn_explosion_particles() -> void:
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


func _on_heatbox_area_body_entered(_body: Node2D) -> void:
	if _body is Jogador:
		_hitbox_are.set_deferred("monitorable", false)
		_invencibili_timer.start()
		_body.update_health("damage", _damage)


func _on_invencibili_timer_timeout() -> void:
	_hitbox_are.set_deferred("monitorable", false)
	
