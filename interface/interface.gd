extends CanvasLayer
class_name Interface

var _current_weapons: Array=[]
@export_category("Objetos")
@export var _wave_and_time: Label
@export var wave_managem: Inimigo_Spawn
@export var _slots_conteiner: HBoxContainer


func _ready() -> void:
	
	globall.interface=self
	_load_cards()
	for _button in get_tree().get_nodes_in_group("chose_button"):
		_button.pressed.connect(_on_button_pressed.bind(_button))
		

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
	print("⏳ Timer acabou, limpando mapa...")
	get_tree().paused=_waves_conteiner
	$WaveAndTime.visible = _wave_state
	$BetweenWavesCOntainer.visible = _waves_conteiner
	
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
	match _button.name:
		"Reroll":
			pass
		"Skip":
			toggle_waves(true,false)
			wave_managem.start_new_wave()
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
						globall.unlocked_weapons[_current_weapons[_i]] + 1
						globall._decrease_money(cust)
						_sloat.hide()
						
					print(_weapon_data[_weapon_level])
					break
				_i +=1
			_button.release_focus()
