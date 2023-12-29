extends RigidBody
class_name Destrutivel


export (int) var saude=100
export (Array,String) var drops=[]
export (String) var nome="Destrutivel"

var atacado=false;

func redesenha():
	if(atacado):
		$label.get_node("nome").set_text(nome)
		$label.get_node("saude").set_text("Saude: "+str(int(saude))+"")
		$label.set_visible(true)
	else:
		$label.set_visible(false)
		$label.get_node("nome").set_text("") 
		$label.get_node("saude").set_text("")
 

export(Array, Resource) var sons_recebendo_dano = [] 
export(Array, Resource) var sons_sendo_destruido = [] 

func filtra_recursos_sonoros(recursos:Array):
	var _arr=[];
	for r in recursos:
		if r is AudioStreamSample: _arr.push_front(r);
	return _arr;

func toca_som(som:AudioStream):
	var voz:AudioStreamPlayer3D=$voz;
	voz.set_stream(som)
	voz.play()

func toca_array(array_sons:Array): 
	randomize()
	var sons=filtra_recursos_sonoros(array_sons);
	if len(sons)>0:
		sons.shuffle()
		toca_som(sons[0])


func destroi():
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

func recebe_dano(dano:int):
	atacado=true
	saude-=dano;
	if (saude>0):
		toca_array(sons_recebendo_dano)
	else:
		destroi()
	redesenha()
	pass

