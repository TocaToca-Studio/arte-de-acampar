extends Control

export (NodePath) var node_relogio
onready var relogio=get_node(node_relogio)

onready var horaLbl=$relogio/labelHora/val
onready var diaLbl=$relogio/labelDia/val

func _ready():
	$relogio/labelDificuldade/val.set_text(Global.DIFICULDADES[Global.dificuldade])




func _process(delta):
	horaLbl.set_text("%02d:%02d" % [relogio.hora, relogio.minutos])
	diaLbl.set_text(str(relogio.dia+1)) ## para exibir o dia zero como sendo dia 1
	
