extends KinematicBody
class_name Personagem

onready var piso_detector = $PisoDetector

#constants
const JUMP_HEIGHT = 3 

var gravity_speed = 0
var pulando=false;

var player_speed = 0 
export (bool) var andando=false
export (float) var velocidade=3.0

export (String) var animacao_andando


export (NodePath) var animation_path 
onready var animation=get_node(animation_path)

export (NodePath) var node_logica 
onready var logica=get_node(node_logica)

export(Array, Resource) var sons_recebendo_dano = [] 
export(Array, Resource) var sons_atacando = [] 


var animal_atacado=null
var atacando=false;
var ataque_timeout=3.0;


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
	toca_array(sons_recebendo_dano)
	logica.recebe_dano(dano)
	pass

func ataca(animal,dano:int): 
	ataque_timeout=1.0;
	atacando=true
	animal_atacado=animal
	animal.recebe_dano(dano)
	# interpola a direção ate mirando no animal que esta atacando
	var self_pos=global_transform.origin
	var dest_pos=animal_atacado.global_transform.origin
	var _dir=dest_pos-self_pos
	#removi a interpolacao kkk
	rotation.y = lerp_angle(rotation.y, atan2(-_dir.x, -_dir.z), 1) #delta * 20
 
	toca_array(sons_atacando)
	pass

func pular():
	pulando=true
 
var pulou_andando=false


func _process(_delta):
	if(andando):
		if(not animation.is_playing()): animation.play(animacao_andando)
	else :
		animation.stop()



func _physics_process(delta): 
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
		if andando:mov=velocidade
	else:
		if pulou_andando: mov=velocidade
	
	if atacando and ataque_timeout>0:
		ataque_timeout-=delta; 
		
	else:
		atacando=false;
	# a interpolacao simula a aceleração e desaceleração
	# na movimentação do personagem existe um efeito interessante,
	# ele tem que desacelerar muito mais rapido do que acelerar
	player_speed=lerp(player_speed, mov,delta*10)
	
	velocity+=-(get_global_transform().basis.z.normalized())*player_speed
		
	gravity_speed = move_and_slide(velocity).y
	
	
