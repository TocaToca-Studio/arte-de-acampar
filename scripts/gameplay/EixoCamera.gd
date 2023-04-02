extends Spatial

export (NodePath) var path_logica
onready var logica=get_node(path_logica)
 
export (NodePath) var path_hud
onready var hud=get_node(path_hud)

export (NodePath) var alice_path
onready var alice=get_node(alice_path)

export (float) var velocidade=2.0

export(float,0.1,1.0) var sensitivity_x = 0.5
export(float,0.1,1.0) var sensitivity_y = 0.4
 
export (NodePath) var path_detector
onready var detector=get_node(path_detector)

var itens_detectados=[]
var mouse_motion = Vector2() 
 
onready var eixoX=$offset/EixoX
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event): 
	if event is InputEventMouseMotion:
		mouse_motion = event.relative  


func _process(delta):  
	if Input.is_action_just_pressed("space") and not logica.is_cansado():
		logica.esforcar(3)
		alice.pular()
		
	alice.andando=Input.is_key_pressed(KEY_W)
		
	rotate_y(deg2rad(20)* - mouse_motion.x * sensitivity_x * delta)
	eixoX.rotate_x(deg2rad(20) * - mouse_motion.y * sensitivity_y * delta)
	eixoX.rotation.x = clamp(eixoX.rotation.x, deg2rad(-47), deg2rad(47))
	
	#player_hand.rotation.x = lerp(player_hand.rotation.x, player_cam.rotation.x, 0.2)
	mouse_motion = Vector2()
	
	
	translation=translation.linear_interpolate(alice.translation,delta*velocidade)
	translation.x=alice.translation.x
	translation.z=alice.translation.z

	if(alice.andando):
		alice.transform=alice.transform.interpolate_with(transform,delta*velocidade*5)
	 
	var _itens_detectados=[]

	for corpo in detector.get_overlapping_bodies():
		if corpo is Coletavel: _itens_detectados.append(corpo)
	
	itens_detectados=_itens_detectados
	if itens_detectados.size()>0:
		hud.set_acao("Pressione F para adicionar o item ao seu inventário","coletavel")
	else: hud.limpa_acao("coletavel")

	if Input.is_key_pressed(KEY_F):
		for item in itens_detectados: 
			logica.adiciona_coletavel(item)
