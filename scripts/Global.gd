extends Node
 
var cena_atual = null

const GRAVIDADE = 9.8
const DIFICULDADES = {
	0:"Aspirante",
	1:"Desbravador entusiasta", 
	2:"Conselheiro",
	3:"Lider Master Avançado"
}

const TEMPOS_DE_JOGO = {
	30 : "30 minutos",
	60 : "1 hora"
}

const INVENTARIOS = {
	0 : { # aspirante
		"0": {
			"item":"lanterna",
			"quantidade":1
		},
		"1": {
			"item":"faca",
			"quantidade":1
		},
		"2": {
			"item":"cantil",
			"quantidade":1,
			"cheio":true
		},
		"3": {
			"item":"fruta",
			"quantidade":10
		}
	},
	1 : { # Desbravador entusiasta
		"0": {
			"item": "lanterna",
			"quantidade":1
		},
		"1": {
			"item":"faca",
			"quantidade":1
		},
		"2": {
			"item":"cantil",
			"quantidade":1,
			"cheio":true,
		},
		"3": {
			"item":"fruta",
			"quantidade":6, 
		}
	},
	2 : { # Conselheiro
		"0": {
			"item":"faca",
			"quantidade":1
		},  
		"1": {
			"item":"cantil",
			"quantidade":1,
			"cheio":true
		},
	},
	3 : {  } # lider master tem que se virar
}


export (int) var dificuldade = 0
export (int) var tempo_de_jogo = 30
export (bool) var game_over = false

func _ready():
	var root = get_tree().root
	cena_atual = root.get_child(root.get_child_count() - 1)


func get_inventario_da_dificuldade():
	return INVENTARIOS[dificuldade]


func solicitar_carregamento_de_cena(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_carregar_cena", path)


func carrega_ilha(): 
	solicitar_carregamento_de_cena("res://scenes/ilha/Ilha.tscn")
	

func gameover():
	game_over=true
	solicitar_carregamento_de_cena("res://scenes/menu/menu.tscn")

func _carregar_cena(path):
	# It is now safe to remove the current scene
	cena_atual.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	cena_atual = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(cena_atual)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().current_scene = cena_atual
	

const ITENS = {
	# itens coletáveis
	"galho" : {
		"nome": "Galho de Árvore",
		"is_coletavel":true,
		"is_ferramenta":true
	},
	"rocha" : {
		"nome": "Rocha rígida",
		"is_coletavel":true, 
	},
	"pena" : {
		"nome": "Pena de ave",
		"is_coletavel":true
	},
	"folha" : {
		"nome": "Folha de árvore",
		"is_coletavel":true
	},
	"coco" : {
		"nome": "Côco com água",
		"is_coletavel":true
	},
	"coco_vazio" : {
		"nome": "Côco sem água",
		"is_coletavel":true
	},
	"osso" : {
		"nome": "Osso de animal",
		"is_coletavel":true,
		"is_ferramenta":true
	},
	"cranio" : {
		"nome": "Crânio de animal",
		"is_coletavel":true
	},
	"carvao" : {
		"nome": "Carvão",
		"is_coletavel":true
	},
	"argila" : {
		"nome": "Argila",
		"is_coletavel":true
	},
	"gordura" : {
		"nome": "Gordura animal",
		"is_coletavel":true
	},
	"algodao" : {
		"nome": "Algodão natural",
		"is_coletavel":true
	},
	"couro" : {
		"nome": "Couro animal",
		"is_coletavel":true
	},
	"sementes" : {
		"nome": "Sementes",
		"is_coletavel":true
	},
	"la" : {
		"nome":"Lã de ovelha",
		"is_coletavel":true
	},
	"dente" : {
		"nome": "Dente de sabre",
		"is_coletavel":true,
		"is_ferramenta": true
	},
	"bambu" : {
		"nome": "Bambu",
		"is_coletavel":true,
		"is_ferramenta" :true
	},
	"planta_venenosa" : {
		"nome": "Planta Venenosa",
		"is_coletavel":true
	},
	"corda": {
		"nome":"Corda ou Cipó",
		"is_coletavel":true
	},

	# itens construtíveis 
	"Bau" : {
		"nome": "Baú",
		"is_construtivel":true
	},
	"Mesa" : {
		"nome": "Mesa improvisada",
		"is_construtivel":true
	},
	"Cama" : {
		"nome": "Cama improvisada",
		"is_construtivel":true
	},
	"abrigo" : {
		"nome": "Abrigo improvisado",
		"is_construtivel":true
	},
	"tecido" : {
		"nome": "Tecido",
		"is_construtivel":true
	},
	"coletor_de_chuva" : {
		"nome": "Coletor de chuva",
		"is_construtivel":true
	},
	"bag" : {
		"nome": "Bag (bolsa improvisada)",
		"is_construtivel":true
	},
	"fogueira" : {
		"nome": "Fogueira",
		"is_construtivel":true
	},
	"rede" : { 
		"nome": "Rede",
		"is_construtivel":true,
		"is_ferramenta" : true
	},
	
	# FERRAMENTAS 
	"cantil": {
		"nome":"Cantil de água",
		"is_construtivel":true,
		"icone":[5,19]
	},
	"lanterna" : {
		"nome":"Lanterna",
		"is_ferramenta": true,
		"icone": [9,10]
	},
	"faca" : { 
		"nome": "Faca",
		"is_ferramenta": true,
		"icone": [6,5]
	}, 
	"tocha" : {
		"nome": "Tocha",
		"is_construtivel":true,
		"is_ferramenta":true
	},
	"marreta" : {
		"nome": "Marretinha",
		"is_construtivel":true,
		"is_ferramenta":true
	},
	"machado" : {
		"nome": "Machadinha",
		"is_construtivel":true,
		"is_ferramenta":true
	},
	"estaca": {
		"nome":"Estaca",
		"is_construtivel":true,
		"is_ferramenta":true 
	},
	"pederneira" : {
		"nome": "Pederneira",
		"is_ferramenta": true
	},
	"isca" : {
		"nome": "Isca de peixe",
		"is_construtivel":true,
		"is_ferramenta":true 
	},
	"vara" : {
		"nome": "Vara de pesca",
		"is_construtivel":true,
		"is_ferramenta":true
	},
	# ALIMENTOS EM GERAL  
	"fruta" : {
		"nome": "Fruta comestível",
		"is_comestivel":true, 
		"icone":[0,14]
	}, 
	"peixe" : {
		"nome": "Peixe",
		"is_comestivel":true
	}, 
	"carne" : {
		"nome": "Carne",
		"is_comestivel":true
	}, 
	
	## MEU SONHO É INSERIR ARCO E FLEXA NESSE JOGO
	## MAS VAMOS SER REALISTA É BEM IMPROVAVEL
	# POR AMOR AS CAUSAS PERDIDAS TALVEZ CONSIGO. 
	# DEIXO ISSO ANOTADO, SE UM DIA EU CONSEGUIR MANDO MENSAGEM PARA AQUELA GATA
	## E PASSO POR TUDO AQUILO DE NOVO> PROMESSA FEITA EM 1 de abril de 2023 no aniversário dela
	## VOCE DEIXOU SAUDADES AINDA TE AMO VOLTA PRA MIM  
}
