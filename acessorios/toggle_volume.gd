extends CanvasLayer
class_name  TV



func _on_sfx_pressed() -> void:
	globall._sfx_state=not globall._sfx_state
	if globall._sfx_state:
		$Volume2/sfx.texture_normal = load("res://Assets (GERAL)/assets/icons/audio/on.png")
	if not globall._sfx_state:
		$Volume2/sfx.texture_normal = load("res://Assets (GERAL)/assets/icons/audio/off.png")
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_click.ogg")



func _on_volume_pressed() -> void:
	globall._volume_state = not globall._volume_state
	if globall._volume_state:
		$Volume2/Volume.texture_normal = load("res://Assets (GERAL)/assets/icons/music/on.png")
	if not globall._volume_state:
		$Volume2/Volume.texture_normal = load("res://Assets (GERAL)/assets/icons/music/off.png")
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_click.ogg")



func _on_mause_entered() -> void:
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_hover.ogg")
	pass # Replace with function body.
