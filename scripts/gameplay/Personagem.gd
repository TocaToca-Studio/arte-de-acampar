extends KinematicBody

onready var piso_detector = $PisoDetector

#constants
const GRAVIDADE = 9.8
const JUMP_HEIGHT = 3 

var gravity_speed = 0
var pular=false;
var player_speed = 0 
export (bool) var andando=false
export (float) var velocidade=3

export (String) var animacao_andando


export (NodePath) var animation_path 
onready var animation=get_node(animation_path)

func pular():
	pular=true
 
var pulou_andando=false


func _process(delta):
	if(andando):
		if(not animation.is_playing()): animation.play(animacao_andando)
	else :
		animation.stop()



func _physics_process(delta): 
	#gravity
	gravity_speed -= GRAVIDADE * delta 
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
		if andando:mov=velocidade
	else:
		if pulou_andando: mov=velocidade
		
	player_speed=lerp(player_speed, mov,delta*3)
	
	velocity+=-(get_global_transform().basis.z.normalized())*player_speed
		
	gravity_speed = move_and_slide(velocity).y
	
	
