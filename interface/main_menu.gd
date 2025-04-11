extends Control
class_name MainMenu



func _on_new_game_pressed() -> void:
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_click.ogg")
	get_tree().change_scene_to_file("res://MenegemLevl/gameçevel.tscn")


func _on_quit_pressed() -> void:
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_cancel.ogg")
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()


func _on_new_game_mouse_entered() -> void:
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_hover.ogg")
