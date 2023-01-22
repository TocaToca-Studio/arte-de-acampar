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

func pular():
	pular=true
 


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
		velocity.y = JUMP_HEIGHT
		pular=false
		
		
	player_speed=lerp(player_speed, velocidade if andando and no_chao else 0,delta*3)
	
	velocity+=-get_global_transform().basis.z.normalized()*player_speed
		
	gravity_speed = move_and_slide(velocity).y
	
	
