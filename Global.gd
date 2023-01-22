extends Node
 
var cena_atual = null

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


export (int) var dificuldade = 0
export (int) var tempo_de_jogo = 3

func _ready():
	var root = get_tree().root
	cena_atual = root.get_child(root.get_child_count() - 1)



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
	
