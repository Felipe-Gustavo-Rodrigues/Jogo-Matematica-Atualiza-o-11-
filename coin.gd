extends Area2D
class_name  Coin

@export var _value_range: Array[int]

func _on_body_entered(_body) -> void:
	if _body is Jogador:
		globall._increase_money(randi_range(
			_value_range[0], _value_range[1]
		))
		queue_free()
		
