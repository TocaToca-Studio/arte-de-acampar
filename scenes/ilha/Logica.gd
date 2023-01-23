extends Node

const DIAS_VIRTUAIS=3

export (float) var segundosRestantes=0
export (int) var hora=6
export (int) var minutos=0 
export (int) var dia=1

export (float) var debug=0
func acabou_tempo():
	print("acabou o tempo!!!")

func _ready():
	segundosRestantes=Global.tempo_de_jogo*60
	
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
	
func _process(delta):
	segundosRestantes-=delta
	atualiza_relogio()
	
	
