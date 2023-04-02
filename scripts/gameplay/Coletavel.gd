extends KinematicBody 
class_name Coletavel

export (String) var codigo_item = "rocha"
export (int) var quantidade = 1

var gravity_speed = 0
 
func _physics_process(delta): 
	#gravity
	gravity_speed -= Global.GRAVIDADE * delta 
	gravity_speed=clamp(gravity_speed,-50,5)
	var velocity = Vector3()
	velocity.y = gravity_speed 
	gravity_speed = move_and_slide(velocity).y
	if is_on_ceiling(): 
		set_physics_process(false)


func get_item():
	return Global.ITENS[codigo_item]
