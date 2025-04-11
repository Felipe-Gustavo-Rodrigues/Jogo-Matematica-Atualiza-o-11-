extends Node2D
class_name BaseArma

const ARROW: PackedScene = preload("res://armas/arco/flecha.tscn")
var _is_atack : bool = false
var _imigo_ref: Enemy
@export_category("Variaveis")
@export var _atack_damage:int
@export var _atack_cooldown: float

@export_category("Objetos")
@export var _atack_timer : Timer
@export var _detectar_area : Area2D
@export var _animacao: AnimationPlayer

func _on_detectar_area_body_entered(_body: Node2D) -> void:
	if _is_atack:
		return
		
	if _body and is_instance_valid(_body) and _body is Enemy:
		_imigo_ref = _body
		_detectar_area.set_deferred("monitoring", false)
		_atack_timer.start(_atack_cooldown)
		_animacao.play("ataque")
		_is_atack = true


func _on_timer_timeout() -> void:
	_is_atack = false
	_detectar_area.set_deferred("monitoring", true)


func _on_area_ataque_body_entered(_body: Node2D) -> void:
	if _body is Enemy:
		_body.update_health(_atack_damage)

func _spawn_projetos()->void:
	if is_instance_valid(_imigo_ref):
		var _direction: Vector2 = global_position.direction_to(_imigo_ref.global_position)
		var _projetio: Projectile = ARROW.instantiate()
		_projetio.global_position=global_position
		_projetio.direction=_direction
		_projetio.atack_damage = _atack_damage
		get_tree().root.call_deferred("add_child", _projetio)
		
func _physics_process(_delta: float) -> void:
	if is_instance_valid(_imigo_ref):
		var direction:Vector2=global_position.direction_to(_imigo_ref.global_position)
		rotation= direction.angle()
		
		
func ulpdate_weapon_damage(_new_damage: int)->void:
	_atack_damage = _new_damage
	
func ulpdate_weapon_cooldown(_new_cooldown: int)->void:
	_atack_cooldown = _new_cooldown
	
func spawn_sfx(_sfx_path: String)->void:
	bgm.spawn_sfx(_sfx_path)
