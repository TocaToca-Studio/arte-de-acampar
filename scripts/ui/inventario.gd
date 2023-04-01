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
	for slot in slots:
		slot.set_text("--") 
	pass
	
	var idx_slot=0
	for codigo_item in logica.inventario:
		if idx_slot>5: break;
		var item_inventario=logica.inventario[codigo_item]
		var item=Global.ITENS[codigo_item]
		slots[idx_slot].set_text(
			str(item_inventario["quantidade"])+"x "+item["nome"]
		)
		idx_slot+=1


func _ready():
	atualiza()
