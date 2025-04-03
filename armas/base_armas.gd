extends Node2D
class_name BaseArma

var _is_atack : bool = false
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
		
	if _body is Enemy:
		_is_atack = true
		_atack_timer.start(_atack_cooldown)
		_animacao.play("ataque")
		_detectar_area.set_deferred("monitoring", false)

func _on_timer_timeout() -> void:
	_is_atack = false
	_detectar_area.set_deferred("monitoring", true)


func _on_area_ataque_body_entered(_body: Node2D) -> void:
	if _body is Enemy:
		_body.update_health(_atack_damage)
