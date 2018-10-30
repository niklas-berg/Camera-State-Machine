extends MeshInstance


var camera: Basis

func _process(delta):
	camera = $"/root/Node/KinematicBody/Camera".global_transform.basis

func _physics_process(delta):
	
	var dir = Vector3()
	
	if(Input.is_action_pressed("ui_up")):
		dir += -camera[2]
	if(Input.is_action_pressed("ui_down")):
		dir += camera[2]
	if(Input.is_action_pressed("ui_left")):
		dir += -camera[0]
	if(Input.is_action_pressed("ui_right")):
		dir += camera[0]
	if(Input.is_action_pressed("jump")):
		dir[1] += 0.1
	if(Input.is_action_pressed("crouch")):
		dir[1] += -0.1

	dir = dir.normalized() * 0.25

	$"/root/Node/Target".global_transform.origin += dir