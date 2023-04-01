extends Control

export (NodePath) var opt_dificuldade_path
onready var opt_dificuldade=get_node(opt_dificuldade_path)
export (NodePath) var opt_tempo_path
onready var opt_tempo=get_node(opt_tempo_path)

export (NodePath) var control_div_menu
onready var div_menu=get_node(control_div_menu)

export (NodePath) var control_div_gameover
onready var div_gameover=get_node(control_div_gameover)

# Called when the node enters the scene tree for the first time.
func _ready(): 
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	div_gameover.set_visible(Global.game_over)
	div_menu.set_visible(!Global.game_over) 

	for d in Global.DIFICULDADES:
		opt_dificuldade.add_item(Global.DIFICULDADES[d],d) 
	
	opt_dificuldade.select(Global.dificuldade)
	
	for d in Global.TEMPOS_DE_JOGO:
		opt_tempo.add_item(Global.TEMPOS_DE_JOGO[d],d) 
	  
	opt_tempo.select(Global.tempo_de_jogo)
	pass # Replace with function body.


func pressionou_botao_play():
	Global.tempo_de_jogo=opt_tempo.get_index()
	Global.dificuldade=opt_dificuldade.get_index()
	Global.carrega_ilha()
	pass

func pressinou_botao_voltar_ao_menu():
	Global.game_over=false
	
	div_gameover.set_visible(Global.game_over)
	div_menu.set_visible(!Global.game_over) 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
