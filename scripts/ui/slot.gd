extends TextureButton

onready var qtd=$qtd

var hud=null

var indice:int=0

func set_indice(_idx): indice=_idx
func get_indice(): return indice

func set_hud(_hud): hud=_hud

var item_inventario=null

func _ready():
	$qtd.set_text("")

func limpa():
	item_inventario=null
	redesenha()

func redesenha():
	if item_inventario==null : 
		qtd.set_text("")
		set_normal_texture(hud.get_icone_vazio(hud.TipoIcone.INVENTARIO))
		return
		
	var item=Global.ITENS[item_inventario["item"]]
	var text=str(item_inventario["quantidade"]) #+"x "+item["nome"]
	#if item_inventario['quantidade']==1 : text=""
	qtd.set_text(text) 
	

	var tipoIcone=hud.TipoIcone.INVENTARIO 
	if pressed:
		tipoIcone=hud.TipoIcone.INVENTARIO_SELECIONADO 
	set_normal_texture(hud.get_item_icone(item_inventario["item"],tipoIcone)) 

func atualiza_item(item_inv):
	item_inventario=item_inv
	redesenha()
