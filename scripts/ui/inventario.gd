extends Control
 
export (NodePath) var node_logica
onready var logica=get_node(node_logica)
 
export (NodePath) var barra_rapida_path
onready var barra_rapida:ItemList=get_node(barra_rapida_path)
 
export (NodePath) var hud_path
onready var hud:HUD=get_node(hud_path)

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

	if(barra_rapida.get_item_count() == 0):
		barra_rapida.add_item("",hud.get_icone_vazio(hud.TipoIcone.INVENTARIO),true) 
		barra_rapida.add_item("",hud.get_icone_vazio(hud.TipoIcone.INVENTARIO),true) 
		barra_rapida.add_item("",hud.get_icone_vazio(hud.TipoIcone.INVENTARIO),true) 
		barra_rapida.add_item("",hud.get_icone_vazio(hud.TipoIcone.INVENTARIO),true) 
		
	atualiza()

func _process(delta):
	if(Input.is_action_just_pressed("abre_inventario")):
		abre_fecha()
		print(logica.inventario)
	
func atualiza():
	for i in range(0,3):
		if logica.inventario.has(str(i)):
			var inv_item=logica.inventario[str(i)]
			var item=Global.ITENS[inv_item["item"]] 
			barra_rapida.set_item_text(i,str(inv_item["quantidade"])+"x")
			if item.has("icone"): 
				 barra_rapida.set_item_icon(i,hud.get_icone(item["icone"][0],item["icone"][1],hud.TipoIcone.INVENTARIO))
			else:
				barra_rapida.set_item_icon(i,hud.get_icone_generico(hud.TipoIcone.INVENTARIO))
		else:
			barra_rapida.set_item_icon(i,hud.get_icone_vazio(hud.TipoIcone.INVENTARIO))
			barra_rapida.set_item_text(i,"")
		
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

 
