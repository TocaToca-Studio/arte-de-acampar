extends Control

export (NodePath) var node_logica
onready var logica=get_node(node_logica)
 
onready var horaLbl=$relogio/labelHora/val
onready var diaLbl=$relogio/labelDia/val
 
onready var saudeLbl=$status/barra_saude/val 
onready var staminaLbl=$status/barra_stamina/val 
onready var fomeLbl=$status/barra_fome/val 
onready var sedeLbl=$status/barra_sede/val 

onready var acao:bool = false
onready var acao_identificador:String = ""
onready var rect_acao=$rect_acao
onready var label_acao=$rect_acao/bg/text_acao
 

func set_acao(texto_acao,identificador): 
	acao=true
	acao_identificador=identificador
	label_acao.set_text(texto_acao)
	rect_acao.set_visible(acao)

func limpa_acao(identificador): 
	if identificador==acao_identificador: 
		acao=false
		acao_identificador=""
		label_acao.set_text("")
		rect_acao.set_visible(acao)

func _ready():
	$relogio/labelDificuldade/val.set_text(Global.DIFICULDADES[Global.dificuldade])
	$relogio/labelTempo/val.set_text(Global.TEMPOS_DE_JOGO[Global.tempo_de_jogo])
 
func porc(val):
	return str(int(val*100.0))+"%"

func _process(_delta): 
	horaLbl.set_text("%02d:%02d" % [logica.hora, logica.minutos])
	diaLbl.set_text(str(logica.dia+1)) ## para exibir o dia zero como sendo dia 1
	saudeLbl.set_text(porc(logica.saude))
	staminaLbl.set_text(porc(logica.stamina))
	fomeLbl.set_text(porc(logica.fome))
	sedeLbl.set_text(porc(logica.sede))

	
