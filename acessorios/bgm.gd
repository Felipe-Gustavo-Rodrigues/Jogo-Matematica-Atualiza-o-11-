extends AudioStreamPlayer2D
class_name BGM

const _SFX_SCENE: PackedScene = preload("res://acessorios/sfx.tscn")

func spawn_sfx(_path: String, _volume_db: float = 0.0)->void:
	if globall._sfx_state == false:
		return
	
	var _sfx: SFX = _SFX_SCENE.instantiate()
	call_deferred("add_child", _sfx)
	_sfx.volume_db = _volume_db
	_sfx.stream = load(_path)
	
	
func _process(_delta:float)->void:
	if globall._volume_state:
		volume_db=-15
	
	if globall._volume_state == false:
		volume_db=-80
