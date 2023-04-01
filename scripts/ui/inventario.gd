extends Control
 
export (NodePath) var node_logica
onready var logica=get_node(node_logica)

onready var slot0=$slot0/val
onready var slot1=$slot1/val
onready var slot2=$slot2/val
onready var slot3=$slot3/val
onready var slot4=$slot4/val
onready var slot5=$slot5/val 

onready  var slots=[slot0,slot1,slot2,slot3,slot4,slot5]



func atualiza():
	
	pass
