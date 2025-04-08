extends Camera2D
class_name PlayCamera

var shaking:bool=false
var _current_strength:float
var _current_length:float

func shack(_strength: float, _length:float) ->void:
	if _current_length != 0:
		return
	shaking=true
	_current_length = _length
	_current_strength = _strength
	
	while _current_length > 0:
		offset = Vector2(
			randf_range(-_current_strength, + _current_strength),
			randf_range(-_current_strength, + _current_strength)
		)
		_current_strength = lerp(_current_strength, 0.0, get_process_delta_time() * 5)
		_current_strength -= get_process_delta_time()
		await get_tree().physics_frame
		
	offset = Vector2.ZERO
	_current_length=0
	_current_strength=0
	shaking=false
	
func reset_shake() -> void:
	shaking=false
	_current_length = 0
	_current_strength = 0
	offset = Vector2.ZERO
