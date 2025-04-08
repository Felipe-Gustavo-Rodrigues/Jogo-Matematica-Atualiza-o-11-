extends Node
class_name Global

var interface: Interface=null
var player=null
var money:int =0

var wapons_list:Dictionary={
	"Espada-pequena":{
		1:{
			"description": "Desbloquei uma arma rapida e de curto alcance. (0.6) (6Dano)",
			"values":{
				"cooldown": 0.8, "damage": 6},
			"cust":10
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
			"cust":10
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
	"Lança":{
		1:{
			"description": "Desbloquei uma arma rapida e de curto alcance. (1.4) (10Dano)",
			"values":{
				"cooldown": 1.4, "damage": 10
			},
			"cust":10
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
	"Lança":0
}

func _increase_money(_value:int)->void:
	interface.update_coin_amount(money)
	money += _value
	
func _decrease_money(_value:int)->void:
	money -= _value
	interface.update_coin_amount(money)
