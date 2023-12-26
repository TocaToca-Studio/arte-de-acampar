extends Control
 
export (NodePath) var node_logica
onready var logica=get_node(node_logica)
 
export (NodePath) var barra_rapida_path
onready var barra_rapida:GridContainer=get_node(barra_rapida_path)
 
export (NodePath) var hud_path
onready var hud:HUD=get_node(hud_path)

var slots=[] 

func abre_fecha():
	set_visible(not is_visible()) 
	Input.set_mouse_mode(
		 Input.MOUSE_MODE_VISIBLE if is_visible() else Input.MOUSE_MODE_CAPTURED
	)
	
	
func _ready():
	hud=get_node(hud_path)
	var grid=$grid;
	
	for i in range(0,4):
		slots.append(barra_rapida.get_node("slot"+str(i))) 
		
	for i in range(0,24):
		slots.append(grid.get_node("slot"+str(i))) 
			 
	for i in range(0,len(slots)):
		slots[i].set_indice(i)
		slots[i].set_hud(hud)
		slots[i].connect("pressed", self, str("apertou_slot"),[i,slots[i]])
		
	atualiza()
	
func obtem_slot_selecionados():
	var selecao={}
	for slot in slots:
		if slot.pressed: 
			selecao[str(slot.get_indice())]=slot
	return selecao

func limpa_selecao():
	for slot in slots:
		slot.set_pressed_no_signal(false)
		slot.redesenha()
		


func apertou_slot(indice,slot): 
	var selecionados=obtem_slot_selecionados();
	print("slots selecionados :"+str(len(selecionados)))
	if len(selecionados)==2:
		selecionados.erase(str(indice))
		var origem=selecionados.keys()[0]
		logica.inv_move_slot(origem,indice)
		# selecionou dois no inventario
		limpa_selecao()
		atualiza()
	
	if not (str(indice) in logica.inventario):
		slots[indice].set_pressed_no_signal(false)
		
	slots[indice].redesenha();
	

func _process(delta):
	if(Input.is_action_just_pressed("abre_inventario")):
		abre_fecha()
		print(logica.inventario)
	
func atualiza():
	if len(slots) == 0:
		return
	if logica == null:
		return
		
	for slot in slots:
		slot.limpa()
		
	for idx in logica.inventario: 
		var slot=slots[int(idx)] 
		slot.atualiza_item(logica.inventario[idx])
		



 
