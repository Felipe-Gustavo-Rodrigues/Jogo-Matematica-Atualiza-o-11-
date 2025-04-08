extends Area2D
class_name Projectile

var direction: Vector2
var atack_damage: int

@export_category("Variavel")
@export var move_speed: float = 128.0


func _ready()->void:
	rotation = direction.angle()
	
func _physics_process(_delta:float)->void:
	translate(
		direction * _delta * move_speed
	)
	

func _on_area_ataque_body_entered(_body) -> void:

	if _body is TileMapLayer:
		queue_free()
		
	if _body is Enemy:
		
		_body.update_health(atack_damage)
		queue_free()
