extends Label
class_name TextPop
func ulpdate_text(_value: int) -> void:
	text = "-"+str(_value)
func _on_animation_player_finished(_anim_name: Script) ->void:
	queue_free() 
