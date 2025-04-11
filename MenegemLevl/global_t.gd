extends Node
class_name Global

var damage:int = 0
var damage_suffer:int=0
var time_alive:int=0
var enemy_kills:int=0
var money_total:int=0

# variaveis responsaveis por desligar e liga son
var _sfx_state:bool= true
var _volume_state:bool=true

var is_changing_scene: bool = false
var interface: Interface=null
var player=null
var money:int =0
var inimigo_spawn: Inimigo_Spawn = null

var wapons_list:Dictionary={
	"Espada-pequena":{
		1:{
			"description": "Desbloquei uma arma rapida e de curto alcance. (0.6) (6Dano)",
			"values":{
				"cooldown": 0.8, "damage": 6},
			"cust":10,
			"scene_path": "res://armas/espadar/espada_pequena.tscn"
		},
		2:{
			"description": "Aumenta o dano em 5.",
			"values":{
				"cooldown": 0.8, "damage": 11},
			"cust":15
		},
		3:{
			"description":"Diminue a recarga em 0.3s",
			"values":{
				"cooldown": 0.5, "damage": 11
			},
			"cust":20
			},
		4:{
			"description":"Diminue a recarga em 0.3s",
			"values":{
				"cooldown": 0.5, "damage": 11
			},
			"cust":25
			},
		5:{
			"description":"Aumenta mais 10 de dano",
			"values":{
				"cooldown": 0.5, "damage": 21
			},
			"cust":30
			}
	},
	"Arco":{
		1:{
			"description": "Desbloquei uma arma rapida e de curto alcance. (0.7) (12Dano)",
			"values":{
				"cooldown": 0.7, "damage": 12
			},
			"cust":10,
			"scene_path": "res://armas/arco/arco.tscn"
		},
		2:{
			"description": "Aumenta o dano em 1.25",
			"values":{
				"cooldown": 0.7, "damage": 16},
			"cust":15
		},
		3:{
			"description":"Diminue a recarga em 0.3s",
			"values":{
				"cooldown": 0.4, "damage": 16
			},
			"cust":20
		},
		4:{
			"description":"Aumenta o dano em 1.50",
			"values":{
				"cooldown": 0.4, "damage": 24
			},
			"cust":25
		},
		5:{
			"description":"Aumenta mais 1.5",
			"values":{
				"cooldown": 0.4, "damage": 36
			},
			"cust":30
		}
	},
	"Lanca":{
		1:{
			"description": "Desbloquei uma arma rapida e de curto alcance. (1.4) (10Dano)",
			"values":{
				"cooldown": 1.4, "damage": 10
			},
			"cust":10,
			"scene_path": "res://armas/lança/lança-1.tscn"
			
		},
		2:{
			"description": "Aumenta o dano em 5.",
			"values":{
				"cooldown": 1.4, "damage": 15},
			"cust":15
		},
		3:{
			"description":"Diminue a recarga em 0.3s",
			"values":{
				"cooldown": 1.1, "damage": 15
			},
			"cust":20
		},
		4:{
			"description":"Diminue a recarga em 0.3s",
			"values":{
				"cooldown": 0.8, "damage": 15
			},
			"cust":25
		},
		5:{
			"description":"Aumenta mais 10 de dano",
			"values":{
				"cooldown": 0.8, "damage": 25
			},
			"cust":30
		}
	}
	
}
var unlocked_weapons: Dictionary={
	"Arco":0,
	"Espada-pequena":1,
	"Lanca":0
}

func _increase_money(_value:int)->void:
	interface.update_coin_amount(money)
	money += _value
	money_total+=_value
	
func _decrease_money(_value:int)->void:
	money -= _value
	interface.update_coin_amount(money)
	
func reset_statisc()->void:
	money=0
	damage= 0
	damage_suffer=0
	time_alive=0
	enemy_kills=0
	money_total=0
	unlocked_weapons={
		"Arco":0,
		"Espada-pequena":1,
		"Lanca":0
	}
