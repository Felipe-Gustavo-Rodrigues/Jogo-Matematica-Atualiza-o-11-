extends CanvasLayer
class_name Interface

@onready var _hearts_state: Dictionary={}
var _heart_index:int=0
var _max_heart_index:int = 2

var questao_clicada:int = 0
var butao_clicado:bool = false

var reroll_cost:int=10
var _current_weapons: Array=[]
@export_category("Objetos")
@export var _wave_and_time: Label
@export var wave_managem: Inimigo_Spawn
@export var _slots_conteiner: HBoxContainer


func _ready() -> void:
	globall.interface=self
	_load_cards()
	$BetweenWavesCOntainer.visible = false
	_hearts_state = {
		"objetos":{
			$HeardConteiner/TextureRect5:3,
			$HeardConteiner/TextureRect4:3,
			$HeardConteiner/TextureRect3:3,
			$HeardConteiner/TextureRect2:3,
			$HeardConteiner/TextureRect:3
			
		},
		"texturas":{
				3:"res://Assets (GERAL)/assets/icons/heart/full.png",
				2:"res://Assets (GERAL)/assets/icons/heart/half.png",
				1:"res://Assets (GERAL)/assets/icons/heart/empty.png"
		}
	}
	for _button in get_tree().get_nodes_in_group("chose_button"):
		_button.pressed.connect(_on_button_pressed.bind(_button))
		_button.mouse_entered.connect(_on_mouse_entered.bind(_button))
		
	globall._increase_money(100)
	$BetweenWavesCOntainer/Background/Rerrol.text = "Rodar -(" + str(reroll_cost) + "g)"
	
	
func update_helth()->void:
	var _hearts_keys: Array = _hearts_state["objetos"].keys()
	if _heart_index >= _hearts_keys.size():
		bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/wave_success.ogg")
		await get_tree().create_timer(0.25).timeout
		globall.inimigo_spawn.clear_map(true)
		return
	_hearts_state["objetos"][_hearts_keys[_heart_index]] -= 1
	var heart_helth:int = _hearts_state["objetos"][_hearts_keys[_heart_index]]
	if heart_helth == 0:
		_heart_index += 1
		update_helth()
		return
	_hearts_keys[_heart_index].texture = load(_hearts_state["texturas"][heart_helth])
	
	
	

func _on_mouse_entered(_button)->void:
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_hover.ogg")

func  update_coin_amount(_new_amount:int)->void:
	$CoinsCOnteiner/Amount.text = str(_new_amount)

func update_wave_and_time_label(wave:int, time_ramaning:int)->void:
	_wave_and_time.text= (
	"Onda " + str(wave) + "\n" +
	"Tempo restante - " + _time_in_secunds(time_ramaning)
)	

func _time_in_secunds(_time:int) -> String:
	var _secunds:float = _time % 60
	@warning_ignore("integer_division")
	var _minuto:float=(_time / 60) % 60
	return"%02d:%02d" % [_minuto, _secunds]

func toggle_waves(_wave_state: bool, _waves_conteiner: bool)->void:
	get_tree().paused=_waves_conteiner
	$WaveAndTime.visible = _wave_state
	$BetweenWavesCOntainer.visible = _waves_conteiner
	$HeardConteiner.visible = _wave_state
	
	if _waves_conteiner:
		_load_cards()
		
func _load_cards()->void:
	var _avaliebles_weapons: Array =[]
	
	for _weapons in globall.unlocked_weapons:
		if globall.unlocked_weapons[_weapons]==5:
			continue
			
		_avaliebles_weapons.append(_weapons)
		
	_avaliebles_weapons.shuffle()
		
	for _container in _slots_conteiner.get_children():
		_container.hide()
		
	var i:int =0
	_current_weapons =[]
	for _weapons in _avaliebles_weapons:
		_current_weapons.append(_weapons)
		if i > _slots_conteiner.get_child_count():
			break
			
		var _slot: ColorRect = _slots_conteiner.get_child(i)
		var _target_level:int = globall.unlocked_weapons[_weapons] + 1
		_slot.get_node("VContener/Title").text = _weapons +  "\n" +"Lvl." + str(_target_level)
		_slot.get_node("VContener/HConteiner/Descript").text = globall.wapons_list[_weapons][_target_level]["description"]
		_slot.get_node("VContener/ButtonCOnteiner/Chose"). text = "Selecionar " + "("+ str(globall.wapons_list[_weapons][_target_level]["cust"])+ "g)"
		_slot.show()
		i += 1
		
	print(_current_weapons)

func _on_button_pressed(_button: Button)->void:
	bgm.spawn_sfx("res://Assets (GERAL)/assets/musics/sfx/button_click.ogg")
	match _button.name:
		"Rerrol":
			if globall.money >= reroll_cost:
				globall._decrease_money(reroll_cost)
				reroll_cost += 5
				_button.text = "Rodar -(" + str(reroll_cost) + "g)"
				_load_cards()
		"Skip":
			toggle_waves(true,false)
			wave_managem.start_new_wave()
			
			reroll_cost = 5
			$BetweenWavesCOntainer/Background/Rerrol.text = "Rodar -(" + str(reroll_cost) + "g)"
			
		"Chose":
			var _i: int=0
			var _childrens: Array = _slots_conteiner.get_children()
			var _sloat:ColorRect = _button.get_parent().get_parent().get_parent()
			for _children in _childrens:
				if _children == _sloat:
					var _weapon_data: Dictionary = globall.wapons_list[_current_weapons[_i]]
					var _weapon_level:int = globall.unlocked_weapons[_current_weapons[_i]]+1
					
					var cust: int = _weapon_data[_weapon_level]["cust"]
					if globall.money >= cust:
						@warning_ignore("standalone_expression")
						globall.unlocked_weapons[_current_weapons[_i]] += 1
						globall._decrease_money(cust)
						_sloat.hide()
						if _weapon_level ==1:
							globall.player.spawn_armas({
								"scene_path": _weapon_data[_weapon_level]["scene_path"],
								"values": _weapon_data[_weapon_level]["values"]
							})
							print("Instanciar arma")
							break
							
						print(_current_weapons[_i])
						get_tree().call_group(_current_weapons[_i], "ulpdate_weapon_damage", _weapon_data[_weapon_level]["values"]["damage"])
						get_tree().call_group(_current_weapons[_i], "ulpdate_weapon_cooldown", _weapon_data[_weapon_level]["values"]["cooldown"])
					
					break
				_i += 1
			_button.release_focus()
		"Alternativa1":
			print("Foi")
			questao_clicada = 3
			butao_clicado=true
			avaliar_resposta()
		"Alternativa2":
			print("Foi")
			questao_clicada = 4
			butao_clicado=true
			avaliar_resposta()
		"Alternativa3":
			print("Foi")
			questao_clicada = 1
			butao_clicado=true
			avaliar_resposta()
		"Alternativa4":
			print("Foi")
			questao_clicada = 2
			butao_clicado=true
			avaliar_resposta()

func colocar_questões(_wave_state_q: bool, _waves_conteiner_q: bool)->void:
	get_tree().paused=_waves_conteiner_q
	$ConteinerPerguntas.visible = _waves_conteiner_q
	
	$ConteinerPerguntas/BckgroundColor/Alternativa1.visible=true
	$ConteinerPerguntas/BckgroundColor/Alternativa2.visible=true
	$ConteinerPerguntas/BckgroundColor/Alternativa3.visible=true
	$ConteinerPerguntas/BckgroundColor/Alternativa4.visible=true
	
	var _perguntas = globall._alternativas[globall.inimigo_spawn._current_wave]["Pergunta"]
	var _respostas:int=globall._alternativas[globall.inimigo_spawn._current_wave]["Resposta"]
	$ConteinerPerguntas/BckgroundColor/ColorRect/Label.text= _perguntas
	print(_perguntas, _respostas)
	
	if _waves_conteiner_q:
		$ConteinerPerguntas/Timer.start()
		

func _on_timer_timeout() -> void:
	$ConteinerPerguntas/BckgroundColor/Alternativa1.visible=false
	$ConteinerPerguntas/BckgroundColor/Alternativa2.visible=false
	$ConteinerPerguntas/BckgroundColor/Alternativa3.visible=false
	$ConteinerPerguntas/BckgroundColor/Alternativa4.visible=false
	butao_clicado=false
	$ConteinerPerguntas/BckgroundColor/ColorRect/Label.text = "Acabou o tempo de 15 segundos"
	await get_tree().create_timer(5).timeout
	get_tree().paused=false
	$ConteinerPerguntas.visible = false
	print("Acabou o tempo")
	wave_managem.start_new_wave()
	
func avaliar_resposta():
	var _respostas = globall._alternativas[globall.inimigo_spawn._current_wave]["Resposta"]
	if questao_clicada == _respostas:
		print("Acertou! Resposta:", _respostas, "Clicada:", questao_clicada)
		$ConteinerPerguntas/Timer.stop()
		$ConteinerPerguntas.visible = false
		globall.player.reset_health()
		toggle_waves(false,true) # volta pro menu de armas
	else:
		print("Errou! Resposta:", _respostas, "Clicada:", questao_clicada)
		$ConteinerPerguntas.visible=true
		$ConteinerPerguntas/BckgroundColor/ColorRect/Label.text = "Você errou, mais sorte na próxima"
		$ConteinerPerguntas/BckgroundColor/Alternativa1.visible = false
		$ConteinerPerguntas/BckgroundColor/Alternativa2.visible = false
		$ConteinerPerguntas/BckgroundColor/Alternativa3.visible = false
		$ConteinerPerguntas/BckgroundColor/Alternativa4.visible = false
		await get_tree().create_timer(5).timeout
		$ConteinerPerguntas/Timer.stop()
		$ConteinerPerguntas.visible = false
		get_tree().paused = false
		wave_managem.start_new_wave()

func reset_hearts() -> void:
	_heart_index = 0
	var _hearts_keys: Array = _hearts_state["objetos"].keys()
	for heart in _hearts_keys:
		_hearts_state["objetos"][heart] = 3
		heart.texture = load(_hearts_state["texturas"][3])
