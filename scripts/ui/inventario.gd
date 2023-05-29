extends Control
 
export (NodePath) var node_logica
onready var logica=get_node(node_logica)
 
export (NodePath) var barra_rapida_path
onready var barra_rapida=get_node(barra_rapida_path)


var slots=[] 

func abre_fecha():
	set_visible(not is_visible()) 
	Input.set_mouse_mode(
		 Input.MOUSE_MODE_VISIBLE if is_visible() else Input.MOUSE_MODE_CAPTURED
	)
	
	
func _ready():
	var grid=$grid;
	for i in range(0,24):
		slots.append(grid.get_node("slot"+str(i)))
	
		barra_rapida.add_item("1")
		barra_rapida.add_item("2")
		barra_rapida.add_item("3")
		barra_rapida.add_item("4")
	
	atualiza()

func _process(delta):
	if(Input.is_action_just_pressed("abre_inventario")):
		abre_fecha()
		print(logica.inventario)
	
func atualiza():
	for i in range(1,4):
		if logica.inventario.has_key(str(i)):
			#
		else:
			pass
		
	pass
	#for slot in slots:
		#slot.set_text("--") 
	#pass
	
	#var idx_slot=0
	#for codigo_item in logica.inventario:
		#if idx_slot>5: break;
		#var item_inventario=logica.inventario[codigo_item]
		#var item=Global.ITENS[codigo_item]
		#slots[idx_slot].set_text(
		#	str(item_inventario["quantidade"])+"x "+item["nome"]
		#)
		#idx_slot+=1

 
