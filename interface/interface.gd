extends CanvasLayer
class_name Interface

@export_category("Objetos")
@export var _wave_and_time: Label

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
