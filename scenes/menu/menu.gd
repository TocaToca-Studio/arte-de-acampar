extends Control

export (NodePath) var opt_dificuldade_path
export (NodePath) var opt_tempo_path
onready var opt_dificuldade=get_node(opt_dificuldade_path)
onready var opt_tempo=get_node(opt_tempo_path)

# Called when the node enters the scene tree for the first time.
func _ready(): 
	for d in Global.DIFICULDADES:
		opt_dificuldade.add_item(Global.DIFICULDADES[d],d) 
	
	opt_dificuldade.select(Global.dificuldade)
	
	for d in Global.TEMPOS_DE_JOGO:
		opt_tempo.add_item(Global.TEMPOS_DE_JOGO[d],d) 
	  
	opt_tempo.select(Global.tempo_de_jogo)
	pass # Replace with function body.


func pressionou_botao_play():
	Global.carrega_ilha()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
