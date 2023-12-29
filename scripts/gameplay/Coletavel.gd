extends KinematicBody 
class_name Coletavel


export (String) var codigo_item = "rocha"
export (int) var quantidade = 1

func set_item(codigo:String,qtd:int=quantidade):
	codigo_item=codigo
	quantidade=qtd
	var hud=get_node("/root/Ilha/Logica/HUD")
	var item=Global.ITENS[codigo]
	$nome.set_text(str(quantidade)+"x "+item["nome"])
	$icone.set_texture(hud.get_item_icone(codigo))
	pass

var drop_vector:Vector3=Vector3.ZERO
func _ready():
	set_item(codigo_item)
	randomize()
	drop_vector=Vector3(rand_range(-1.0, 1.0),1,rand_range(-1.0, 1.0))*6

var gravity_speed = 0


 
func _physics_process(delta): 
	# gravity
	gravity_speed -= Global.GRAVIDADE * delta 
	gravity_speed = clamp(gravity_speed,-50,20)

	drop_vector=lerp(drop_vector,Vector3.ZERO,delta*3)
	var velocity = Vector3()
	#velocity += drop_vector*delta
	velocity.y = gravity_speed 
	gravity_speed = move_and_slide(velocity).y
	
	

	if is_on_ceiling(): 
		set_physics_process(false)


func get_item():
	return Global.ITENS[codigo_item]
