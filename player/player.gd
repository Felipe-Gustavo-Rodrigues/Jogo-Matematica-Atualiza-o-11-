extends CharacterBody2D
class_name Jogador

var _last_direction: Vector2 = Vector2(0, 1)
@export_category("Variebles")
@export var _move_speed:float = 256.0
@export var _health: int = 10
@export var _max_health: int
@export_category("Objetos")
@export var _dust: CPUParticles2D = null
@export var _auxiliar_animacao: AnimationPlayer

@onready var _sprite: Sprite2D = $Sprite2D

func _ready()->void:
	_max_health=_health
	globall.player=self
	get_tree().paused=false
func _physics_process(_delta: float) -> void:
	_move()
	


func _move() -> void:
	var _direction: Vector2 = Input.get_vector(
	 "move_left", "move_right", "move_up", "move_down")
	if _direction != Vector2.ZERO:  # Se estiver se movendo
		_last_direction = _direction  # Atualiza a última direção
	velocity = _direction * _move_speed
	move_and_slide()
	update_sprite_direction(_direction)  # Passa _direction corretamente

func update_sprite_direction(_direction: Vector2) -> void:
	if _direction == Vector2.ZERO:  # Se estiver parado, usa a última direção
		if _last_direction.y < 0:
			_sprite.region_rect = Rect2(17, 23, 22, 23)  # Parado virado para cima
			_sprite.flip_h = false
		elif _last_direction.y > 0:
			_sprite.region_rect = Rect2(17, 3, 22, 23)  # Parado virado para baixo
			_sprite.flip_h = false
		elif _last_direction.x < 0:
			_sprite.region_rect = Rect2(17, 49, 22, 23)  # Parado virado para a esquerda
			_sprite.flip_h = true
		elif _last_direction.x > 0:
			_sprite.region_rect = Rect2(17, 49, 22, 23)  # Parado virado para a direita
			_sprite.flip_h = false
	else:
		if _direction.y < 0:
			_sprite.region_rect = Rect2(39, 23, 22, 23) 
		elif _direction.y > 0:
			_sprite.region_rect = Rect2(39, 3, 22, 23)  
		elif _direction.x < 0:
			_sprite.region_rect = Rect2(39, 49, 22, 23)
			_sprite.flip_h = true 
		elif _direction.x > 0:
			_sprite.region_rect = Rect2(39, 49, 22, 23)
			_sprite.flip_h = false


func update_health(_type: String, _value) ->void:
	match _type:
		"damage":
			_health -= _value
			_auxiliar_animacao.play("hit")
			if _health <=0:
				print("game Hover")
				queue_free()
		"heal":
			_health += _value
			if  _health > _max_health:
				_health = _max_health
				
func reset_health()->void:
	print(" Antiga VIda do personagem ", str(_health))
	_health = _max_health
	print("VIda do personagem ", str(_health))
