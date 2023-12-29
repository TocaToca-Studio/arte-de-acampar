extends KinematicBody
class_name Animal

onready var piso_detector = $PisoDetector 
onready var detector = $Detector 
#constants
const JUMP_HEIGHT = 3 

var gravity_speed = 0
var pulando=false;
var player_speed = 0 
export (String) var nome="Cachorro"
export (int) var saude=100
export (bool) var andando=false
export (float) var velocidade=3.0
export (String) var animacao_andando
export (bool) var perseguindo=false
export (int) var dano_ataque=8
export (bool) var vivo= true

export (NodePath) var node_logica
onready var logica=get_node(node_logica)
 
func redesenha():
	if(vivo):
		$label.get_node("nome").set_text(nome)
		$label.get_node("saude").set_text("Saude: "+str(int(saude))+"")
	else:
		$label.get_node("nome").set_text(nome+ " (derrotado)")
		$label.get_node("saude").set_text("(morto)")
 
var morte_timeout=0;
func morre():
	morte_timeout=3.0
	vivo=false;
	andando=false;
	pulando=false;
	atacando=false 
	saude=0 
	redesenha()


func _ready():
	andando=1
	rotacao=rand_range(-1,1)
	redesenha();
	
func pular():
	pulando=true
 
var pulou_andando=false

var atacando=false;
var ataque_timeout=3.0;

var tempo_vivo=0.0

var rotacao=0.0
var rotacao_interpolada=0.0

func _physics_process(delta):  
	if saude<0: morre() 
	if not vivo: 
		if morte_timeout>0:
			morte_timeout-=delta;  
		else:
			var posicao=get_global_transform().origin
			posicao.y+=2

			logica.instancia_coletavel("carne",3,posicao)
			posicao.z+=1
			logica.instancia_coletavel("osso",2,posicao)
			posicao.x-=2
			logica.instancia_coletavel("couro",1,posicao)
			queue_free() 
		return

	if atacando and ataque_timeout>0:
		ataque_timeout-=delta;
	else:
		atacando=false;

	var ocupado=atacando || not vivo;
	

	var personagem_detectado=null
	#detecta corpos em movimentos se o personagem nao estiver ocupado
	if not ocupado:
		for corpo in detector.get_overlapping_bodies(): 
			if corpo is Personagem: personagem_detectado=corpo


	tempo_vivo+=delta; 
	if perseguindo:
		#  chance de dar um pulo a cada 3 segundos se estiver andando
		if int(tempo_vivo*1000.0)%1500==0 and rand_range(0,1)<0.4: pular()

		# cancela a rotacao padrao
		rotacao=0  

		# anda ate encontrar o personagem 
		andando=not (personagem_detectado is Personagem)

		# interpola a direção ate mirando no player
		var self_pos=global_transform.origin
		var dest_pos=logica.personagem.global_transform.origin
		var _dir=dest_pos-self_pos
		rotation.y = lerp_angle(rotation.y, atan2(-_dir.x, -_dir.z), delta * 3)
			
		if (personagem_detectado is Personagem) and not atacando:
			# todo segundo, caso nao esteja atacando o personagem, tem 70% de chance de atacar
			if int(tempo_vivo*1000.0)%1000==0 and rand_range(0,1)<0.7: ataca(personagem_detectado,dano_ataque)
	else:
		# da um pulo a cada 10 segundos se estiver andando
		if int(tempo_vivo*1000.0)%10000==0 and andando: pular()

		# a cada 5 segundos decide se vai continuar andadno
		if int(tempo_vivo*1000.0)%3000==0: 
			andando=rand_range(0,1)<0.3;
		
		# a cada 3 segundos decide se vai olhar para outro lugar
		if int(tempo_vivo*1000.0)%1500==0: 
			# 30 % de chance de olhar para outro lugar
			if(rand_range(0,1)<0.2 || (andando && rand_range(0,1)<0.5)):
				rotacao=rand_range(-1,1);
			else:
				rotacao=0
		
		rotacao_interpolada=lerp(rotacao_interpolada,rotacao,delta)
		rotate_y(rotacao_interpolada*delta)
		
	#gravity
	gravity_speed -= Global.GRAVIDADE * delta 
	gravity_speed=clamp(gravity_speed,-50,5)
	#character moviment
	var velocity = Vector3()  
	velocity.y = gravity_speed 
	var no_chao=piso_detector.is_colliding()
	#jump
	if pulando and no_chao:
		pulou_andando=andando;
		velocity.y = JUMP_HEIGHT
		pulando=false
		
	
	var mov=0
	if no_chao:
		if andando: mov=velocidade
	else:
		if pulou_andando: mov=velocidade
		 

	# a interpolacao simula a aceleração e desaceleração
	# na movimentação do personagem existe um efeito interessante,
	# ele tem que desacelerar muito mais rapido do que acelerar
	player_speed=lerp(player_speed, mov,delta*10)
	
	velocity+=-(get_global_transform().basis.z.normalized())*player_speed
		
	gravity_speed = move_and_slide(velocity).y
	
	
export(Array, Resource) var sons_recebendo_dano = [] 
export(Array, Resource) var sons_atacando = [] 

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


func recebe_dano(dano:int):
	perseguindo=true
	saude-=dano;
	toca_array(sons_recebendo_dano)
	redesenha()
	pass

func ataca(personagem:Personagem,dano:int): 
	ataque_timeout=3.0;
	atacando=true
	personagem.recebe_dano(dano)
	toca_array(sons_atacando)
	pass
