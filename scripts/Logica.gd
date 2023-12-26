extends Node

const DIAS_VIRTUAIS = 3

## quanto menor mais rapido
var fator_fome = 250.0   
var fator_sede = 180.0    
var fator_stamina = 50.0  
var fator_recupera_stamina = 70.0

export (float) var segundosRestantes=0.0
export (int) var hora=6
export (int) var minutos=0 
export (int) var dia=1

export (float) var debug=0.0

export (float) var saude=1.0
export (float) var stamina=1.0
export (float) var fome=1.0
export (float) var sede=1.0

# intensidade do esforço é usada para calcular o gasto da stamina constante
export (float) var esforco=0.0

export (NodePath) var path_hud_inventario
onready var hud_inventario=get_node(path_hud_inventario)



##########################INVENTARIO####################################

const NUMERO_DE_SLOTS = 4 + 24 
# os primeiros  4 itens são a barra rapida
var inventario={}

func inv_obtem_posicao_item(item:String):
	for i in inventario:
		if inventario[str(i)].item==item: return str(i) 
	return null
	
func inv_obtem_posicao_livre():
	for i in range(NUMERO_DE_SLOTS):
		if not inventario.has(str(i)): return str(i)
	return null

func adiciona_item(item:String,quantidade : int = 1):
	var i = inv_obtem_posicao_item(item)
	if i==null:
		inventario[inv_obtem_posicao_livre()]={"item":item,"quantidade":quantidade}
	else:
		inventario[i]["quantidade"]+=quantidade

func inv_move_slot(origem,destino):
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
	var i = inv_obtem_posicao_item(item)
	if i==null: return true
	
	inventario[i]["quantidade"]-=quantidade
	if inventario[i]["quantidade"]<=0: inventario.erase(i)
	
func inv_usa_item(indice):
	remove_item(inventario[str(indice)]["item"],1)
	

func adiciona_coletavel(item:Coletavel):
	adiciona_item(item.codigo_item,item.quantidade)
	
	item.queue_free()
	hud_inventario.atualiza()

####################################
func esforcar(fat):
	stamina-=(1/fator_stamina)*fat

func is_cansado():
	return stamina<0.3
  

func _ready():
	segundosRestantes=Global.tempo_de_jogo*60
	## carrega inventario de acordo com a dificuldade
	inventario= Global.INVENTARIOS[Global.dificuldade]
	#hud_inventario.atualiza()
	
func atualiza_relogio():
	var minutos_totais=DIAS_VIRTUAIS*24*60
	var fator_minutos_virtuais=minutos_totais/float(Global.tempo_de_jogo)
	var minutos_virtuais_restantes=(segundosRestantes/60.0)*fator_minutos_virtuais
	# offset 360 minutos para começar 6 da manhã 
	var minutos_virtuais_passados=(minutos_totais-minutos_virtuais_restantes)+360.0
	#debug=minutos_virtuais_restantes
	minutos=int(minutos_virtuais_passados)%60
	hora=int(minutos_virtuais_passados/60.0);
	dia=hora/24
	hora=hora%24 
	 
func is_dia(): 
	return hora>=6 and hora<=18

func _process(delta):
	segundosRestantes-=delta
	atualiza_relogio() 
	
	fome-=delta/fator_fome
	sede-=delta/fator_sede
	stamina-=(delta/fator_stamina)*esforco
	stamina+=delta/fator_recupera_stamina

	stamina=clamp(stamina,0.0,1.0) 
	fome=	clamp(fome,0.0,1.0)
	sede=	clamp(sede,0.0,1.0)
	saude=	clamp(saude,0.0,1.0)

	# se alguma variavel desta for menor do que zero é game over
	for v in [saude,fome,sede,segundosRestantes]:
		if v<=0:
			Global.gameover()
			pass
	
	
	
	
