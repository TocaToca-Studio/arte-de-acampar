extends Control

export (NodePath) var node_logica
onready var logica=get_node(node_logica)
 
onready var horaLbl=$relogio/labelHora/val
onready var diaLbl=$relogio/labelDia/val
 
onready var saudeLbl=$status/barra_saude/val 
onready var staminaLbl=$status/barra_stamina/val 
onready var fomeLbl=$status/barra_fome/val 
onready var sedeLbl=$status/barra_sede/val 

func _ready():
	$relogio/labelDificuldade/val.set_text(Global.DIFICULDADES[Global.dificuldade])
 
func porc(val):
	return str(int(val*100.0))+"%"

func _process(delta):
	horaLbl.set_text("%02d:%02d" % [logica.hora, logica.minutos])
	diaLbl.set_text(str(logica.dia+1)) ## para exibir o dia zero como sendo dia 1
	saudeLbl.set_text(porc(logica.saude))
	staminaLbl.set_text(porc(logica.stamina))
	fomeLbl.set_text(porc(logica.fome))
	sedeLbl.set_text(porc(logica.sede))

	
