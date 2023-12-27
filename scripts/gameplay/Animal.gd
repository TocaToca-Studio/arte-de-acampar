extends KinematicBody
class_name Animal

onready var piso_detector = $PisoDetector

#constants
const JUMP_HEIGHT = 3 

var gravity_speed = 0
var pular=false;
var player_speed = 0 
export (bool) var andando=false
export (float) var velocidade=3.0

export (String) var animacao_andando

 
func pular():
	pular=true
 
var pulou_andando=false

var tempo_vivo=0.0

func _physics_process(delta): 
	tempo_vivo+=delta;

	var dir=Vector3.ZERO

	# da um pulo a cada 10 segundos se estiver andando
	if int(tempo_vivo*1000.0)%10000==0 and andando: pular()

		# a cada 5 segundos decide se vai continuar andadno
	if int(tempo_vivo*4000.0)%5000==0: 
		andando=rand_range(0,1)<0.3;
 
	
	#gravity
	gravity_speed -= Global.GRAVIDADE * delta 
	gravity_speed=clamp(gravity_speed,-50,5)
	#character moviment
	var velocity = Vector3()  
	velocity.y = gravity_speed 
	var no_chao=piso_detector.is_colliding()
	#jump
	if pular and no_chao:
		pulou_andando=andando;
		velocity.y = JUMP_HEIGHT
		pular=false
		
	
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
	
	
