extends Control

export (NodePath) var opt_dificuldade_path
export (NodePath) var opt_tempo_path
onready var opt_dificuldade=get_node(opt_dificuldade_path)
onready var opt_tempo=get_node(opt_tempo_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	opt_dificuldade.add_item("Aspirante")
	opt_dificuldade.add_item("Desbravador entusiasta")
	opt_dificuldade.add_item("Conselheiro")
	opt_dificuldade.add_item("Lider Master Avançado")
	
	
	
	opt_tempo.add_item("30 minutos")
	opt_tempo.add_item("1 Hora") 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
