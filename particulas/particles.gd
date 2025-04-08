extends CPUParticles2D
class_name Particles

func _on_life_time_timeout() -> void:
	queue_free()
