extends Control
 
export (NodePath) var node_logica
onready var logica=get_node(node_logica)
 
export (NodePath) var barra_rapida_path
onready var barra_rapida:GridContainer=get_node(barra_rapida_path)
 
export (NodePath) var hud_path
onready var hud:HUD=get_node(hud_path)

export (NodePath) var sidebar_path
onready var sidebar=get_node(sidebar_path)



var slots=[] 


func abre():
	set_visible(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func fecha():
	set_visible(false)
	limpa_selecao()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func abre_fecha():
	if visible: fecha()
	else: abre()
	 

func clicou_usar():
	usa_item(obtem_slot_selecionados().keys()[0])
	limpa_selecao()
	atualiza()

func clicou_equipar():
	var idx_sel=obtem_slot_selecionados().keys()[0]
	var item=inventario[str(idx_sel)]["item"]
	equipa_item(item)
	limpa_selecao();
	atualiza();
	



##########################INVENTARIO####################################

const NUMERO_DE_SLOTS = 4 + 24 
# os primeiros  4 itens são a barra rapida
var inventario={}

func obtem_posicao_item(item:String):
	for i in inventario:
		if inventario[str(i)].item==item: return str(i) 
	return null
	
func obtem_posicao_livre():
	for i in range(NUMERO_DE_SLOTS):
		if not inventario.has(str(i)): return str(i)
	return null

func adiciona_item(item:String,quantidade : int = 1): 
	var i = obtem_posicao_item(item)
	if i==null:
		inventario[obtem_posicao_livre()]={"item":item,"quantidade":quantidade}
	else:
		inventario[i]["quantidade"]+=quantidade

func move_slot(origem,destino):
	if not (str(origem) in inventario):
		print("ERRO ao mover slot, slot origem não existe.")
		return
	
	if str(destino) in inventario:
		var bkp_destino=inventario[str(destino)]
		inventario[str(destino)]=inventario[str(origem)]
		inventario[str(origem)]=bkp_destino
	else: 
		inventario[str(destino)]=inventario[str(origem)]
		inventario.erase(str(origem))

func remove_item(item:String,quantidade : int = 999):
	var i = obtem_posicao_item(item)
	if i==null: return true
	
	inventario[i]["quantidade"]-=quantidade
	if inventario[i]["quantidade"]<=0: inventario.erase(i)
	
func usa_item(indice):
	remove_item(inventario[str(indice)]["item"],1)
	

func adiciona_coletavel(item:Coletavel):
	adiciona_item(item.codigo_item,item.quantidade)
	
	item.queue_free()
	atualiza()

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
		
	sidebar=get_node(sidebar_path)
	sidebar.get_node("btnUsar").connect("pressed",self,"clicou_usar")
	sidebar.get_node("btnEquipar").connect("pressed",self,"clicou_equipar")

	
	atualiza()
	
func obtem_slot_selecionados():
	var selecao={}
	for slot in slots:
		if slot.pressed: 
			selecao[str(slot.get_indice())]=slot
	return selecao

func limpa_selecao(): 
	sidebar.set_visible(false) 
	for slot in slots:
		slot.set_pressed_no_signal(false)
		slot.redesenha()
		


func apertou_slot(indice,slot): 
	var selecionados=obtem_slot_selecionados();
	print("slots selecionados :"+str(len(selecionados)))  

	if len(selecionados)==2:
		selecionados.erase(str(indice))
		var origem=selecionados.keys()[0]
		move_slot(origem,indice)
		# selecionou dois no inventario
		limpa_selecao()
		atualiza()
	
	if not (str(indice) in inventario):
		slots[indice].set_pressed_no_signal(false)
		
	atualiza()
	
 
func atualiza():
	if len(slots) == 0:
		return
	if logica == null:
		return
		
	for slot in slots:
		slot.limpa()
		
	for idx in inventario: 
		var slot=slots[int(idx)] 
		slot.atualiza_item(inventario[idx])

	
	var selecionados=obtem_slot_selecionados();
	if len(selecionados)==1 and visible:
		var item_selecionado=inventario[str(selecionados.keys()[0])]
		var info_selecionado=Global.ITENS[item_selecionado["item"]]
		sidebar.get_node("btnUsar").set_visible("is_comestivel" in info_selecionado)
		sidebar.get_node("btnEquipar").set_visible("is_equipavel" in info_selecionado)
		sidebar.set_visible(true) 
	else:
		sidebar.set_visible(false)
		


export (NodePath) var euipamento_path
onready var equipamento=get_node(euipamento_path)
	
var equipamento_ativo="punho";

func equipa_item(item_id:String): 
	equipamento_ativo=item_id
	var item=Global.ITENS[item_id]
	equipamento.get_node("nome").set_text(item["nome"])
	equipamento.get_node("dano").set_text("+"+str(item["dano"])+" dano de ataque")

	var node_icone=equipamento.get_node("icone") 
	node_icone.set_texture(hud.get_item_icone(item_id)) 

func get_item_equipado():
	return Global.ITENS[equipamento_ativo]






 
