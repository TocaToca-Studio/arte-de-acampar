extends RigidBody
class_name Destrutivel


export (int) var saude=100
export (Array,String) var drops=[]
export (String) var nome="Destrutivel"

var atacado=false;

func redesenha():
	if(atacado and (not destruido)):
		$label.get_node("nome").set_text(nome)
		$label.get_node("saude").set_text("Saude: "+str(int(saude))+"")
		$label.set_visible(true)
	else:
		$label.set_visible(false)
		$label.get_node("nome").set_text("") 
		$label.get_node("saude").set_text("")
 

export(Array, Resource) var sons_recebendo_dano = [] 
export(Array, Resource) var sons_sendo_destruido = [] 
export(float) var destruir_timeout=2.0
var destruido=false;

func _process(delta):
	if destruido:
		destruir_timeout-=delta
		if(destruir_timeout<0): destruir_de_vez()

func filtra_recursos_sonoros(recursos:Array):
	var _arr=[];
	for r in recursos:
		if r is AudioStreamSample: _arr.push_front(r);
	return _arr;

func toca_som(som:AudioStream):
	var voz=$voz;
	voz.set_stream(som)
	voz.play()

func toca_array(array_sons:Array): 
	randomize()
	var sons=filtra_recursos_sonoros(array_sons);
	if len(sons)>0:
		sons.shuffle()
		toca_som(sons[0])


func destruir_de_vez():
	var logica=get_node("/root/Ilha/Logica")
	var posicao=$label.get_global_transform().origin
	posicao.y+=2

	logica.instancia_coletavel("carne",3,posicao)
	posicao.z+=1
	logica.instancia_coletavel("osso",2,posicao)
	posicao.x-=2
	logica.instancia_coletavel("couro",1,posicao) 

	queue_free()
	pass

func destroi():
	toca_array(sons_sendo_destruido) 
	destruido=true
	pass

func recebe_dano(dano:int):
	atacado=true
	if not destruido: 
		saude-=dano;
		toca_array(sons_recebendo_dano)
		if saude<0: destroi()  
	redesenha()
	pass

