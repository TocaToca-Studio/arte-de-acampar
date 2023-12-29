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

var coletaveis_detectados=[]
var mouse_motion = Vector2() 
 
onready var eixoX=$offset/EixoX
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func capturando_movimento() : 
	return Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED
 
func _input(event): 
	if event is InputEventMouseMotion and capturando_movimento():
		mouse_motion = event.relative  
	else: mouse_motion = Vector2.ZERO


func _process(delta):  
	if  capturando_movimento():
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
	 
	
	var coletavel_detectado=null
	var destrutivel_detectado=null
	var animal_detectado=null

	var ocupado=false
	ocupado=logica.personagem.atacando ;

	#detecta corpos em movimentos se o personagem nao estiver ocupado
	if not ocupado:
		for corpo in detector.get_overlapping_bodies():
			if corpo is Coletavel: coletavel_detectado=corpo
			if corpo is Animal and  corpo.vivo : animal_detectado=corpo
			if corpo is Destrutivel : destrutivel_detectado=corpo
	
	if coletavel_detectado is Coletavel:
		var item=coletavel_detectado.get_item()
		hud.set_acao("Pressione F para pegar "+item["nome"]+"","coletavel")
	else:
		hud.limpa_acao("coletavel")
		
	if animal_detectado is Animal and not logica.personagem.andando: 
		hud.set_acao("Pressione F para atacar "+animal_detectado.nome+"","animal")
	else:
		hud.limpa_acao("animal")
		 
	if (destrutivel_detectado is Destrutivel) and (not ocupado) and (not logica.personagem.andando) and (not destrutivel_detectado.destruido) : 
		hud.set_acao("Pressione F para atingir "+destrutivel_detectado.nome+"","destrutivel")
	else:
		hud.limpa_acao("destrutivel")
			

	if Input.is_key_pressed(KEY_F)  and capturando_movimento() and not ocupado: 
		if coletavel_detectado is Coletavel:
			logica.hud_inventario.adiciona_coletavel(coletavel_detectado)
			hud.limpa_acao("animal")
		elif animal_detectado is Animal:
			logica.ataca(animal_detectado) 
			hud.limpa_acao("coletavel")
		elif destrutivel_detectado is Destrutivel:
			logica.ataca(destrutivel_detectado) 
			hud.limpa_acao("destrutivel")
