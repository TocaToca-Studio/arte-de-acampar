extends Node

const DIAS_VIRTUAIS = 3

## quanto menor mais rapido
const FATOR_FOME = 180.0   
const FATOR_SEDE = 40.0   

export (float) var segundosRestantes=0.0
export (int) var hora=6
export (int) var minutos=0 
export (int) var dia=1

export (float) var debug=0.0

export (float) var saude=1.0
export (float) var stamina=1.0
export (float) var fome=1.0
export (float) var sede=1.0


 

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
	
	fome-=delta/FATOR_FOME
	sede-=delta/FATOR_SEDE


	# se alguma variavel desta for menor do que zero é game over
	for v in [saude,stamina,fome,sede,segundosRestantes]:
		if v<=0:
			Global.gameover()
			pass
	
	
	
	
