extends Control
class_name HUD
 
export (NodePath) var node_logica
onready var logica=get_node(node_logica)
 
export (NodePath) var horaLbl_path
onready var horaLbl=get_node(horaLbl_path)
export (NodePath) var diaLbl_path
onready var diaLbl=get_node(diaLbl_path)
 
export (NodePath) var saudeLbl_path
onready var saudeLbl=get_node(saudeLbl_path)
export (NodePath) var staminaLbl_path
onready var staminaLbl=get_node(staminaLbl_path)
export (NodePath) var fomeLbl_path
onready var fomeLbl=get_node(fomeLbl_path)
export (NodePath) var sedeLbl_path
onready var sedeLbl=get_node(sedeLbl_path)

export (NodePath) var  marcador_dia_path
onready var marcador_dia=get_node(marcador_dia_path)



export (NodePath) var dificuldadeLbl_path
onready var dificuldadeLbl=get_node(dificuldadeLbl_path)

export (NodePath) var tempoLbl_path
onready var tempoLbl=get_node(tempoLbl_path)
export (NodePath) var camera_path
onready var camera=get_node(camera_path)

onready var acao:bool = false
onready var acao_identificador:String = ""
onready var rect_acao=$rect_acao
onready var label_acao=$rect_acao/bg/text_acao


export (Texture) var icones_inventario
export (Texture) var icones_inventario_selecionado
export (Texture) var icones_redondo
export (Texture) var icones_redondo_selecionado
export (Texture) var icones
 
enum TipoIcone {
	INVENTARIO = 1,
	INVENTARIO_SELECIONADO,
	REDONDO,
	ICONES	
}

func get_icone(x:int,y:int,atlas:int = TipoIcone.ICONES) -> AtlasTexture:
	var text:Texture=icones
	 
	if atlas == TipoIcone.INVENTARIO: text = icones_inventario
	elif atlas == TipoIcone.INVENTARIO_SELECIONADO: text = icones_inventario_selecionado
	elif atlas == TipoIcone.REDONDO: text = icones_redondo
	
	var t=AtlasTexture.new()
	t.set_atlas(text)
	t.set_region(Rect2(x*32,y*32,32,32))
	return t

func get_icone_vazio(atlas:int = TipoIcone.ICONES) -> AtlasTexture: return get_icone(12,0,atlas)
func get_icone_generico(atlas:int = TipoIcone.ICONES) -> AtlasTexture: return get_icone(15,3,atlas)
	

var amb_dia = preload("res://scenes/ilha/dia.tres")
var amb_noite = preload("res://scenes/ilha/noite.tres")
var text_dia = preload("res://texturas/hud/dia.tres")
var text_noite = preload("res://texturas/hud/noite.tres")
var exibindo_dia=true


func set_acao(texto_acao,identificador): 
	acao=true
	acao_identificador=identificador
	label_acao.set_text(texto_acao)
	rect_acao.set_visible(acao)

func limpa_acao(identificador): 
	if identificador==acao_identificador: 
		acao=false
		acao_identificador=""
		label_acao.set_text("")
		rect_acao.set_visible(acao)

func _ready(): 
	#tempoLbl.set_text(Global.TEMPOS_DE_JOGO[Global.tempo_de_jogo])
	dificuldadeLbl.set_text(Global.DIFICULDADES[Global.dificuldade])
 
func porc(val):
	return val*100.0

func _process(_delta): 
	horaLbl.set_text("%02d:%02d" % [logica.hora, logica.minutos])
	#diaLbl.set_text(str(logica.dia+1)) ## para exibir o dia zero como sendo dia 1
	saudeLbl.set_value(porc(logica.saude))
	staminaLbl.set_value(porc(logica.stamina))
	fomeLbl.set_value(porc(logica.fome))
	sedeLbl.set_value(porc(logica.sede))
	
	var is_dia=logica.is_dia()
	if is_dia!=exibindo_dia:
		if is_dia: 
			marcador_dia.set_texture(text_dia)
			camera.set_environment(amb_dia)
		else:
			marcador_dia.set_texture(text_noite) 
			camera.set_environment(amb_noite)
		exibindo_dia=is_dia
		

	
