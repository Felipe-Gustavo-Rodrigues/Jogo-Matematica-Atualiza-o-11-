extends AudioStreamPlayer2D
class_name SFX

func _on_finished() -> void:
	queue_free()
