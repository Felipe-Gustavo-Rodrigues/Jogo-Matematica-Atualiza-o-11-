extends Control
class_name AfterGame

func _ready() -> void:
	print("AfterGame carregado")
	$Estatisticas/InimigosKill.text="Kill: " + str(globall.enemy_kills)
	$Estatisticas/TimeAline.text="Tempo Vivo: " + str(globall.time_alive)
	$Estatisticas/Damage.text="Dano: " + str(globall.damage)
	$Estatisticas/MoneyEarmed.text="Dinheiro: " + str(globall.money_total)
	$Estatisticas/DamageSufrer.text="Dano Recebido: " + str(globall.damage_suffer)
	print("AfterGame carregado")
	
func _on_quit_2_pressed() -> void:
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_click.ogg")
	get_tree().change_scene_to_file("res://MenegemLevl/gameçevel.tscn")


func _on_menu_pressed() -> void:
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_click.ogg")
	get_tree().change_scene_to_file("res://interface/main_menu.tscn")


func _on_sair_pressed() -> void:
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_cancel.ogg")
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()


func _on_mouse_entered() -> void:
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_hover.ogg")
