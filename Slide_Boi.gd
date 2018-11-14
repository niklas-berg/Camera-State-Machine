extends "Camera_Interface.gd"
#
#var phi: float
#var theta: float
#var new_pos: Vector3
#var prev_pos: Vector3
#var vel: Vector3
#var t = Transform()
#
#var remember_angle: float
#var toggle_boi = true
#
#func enter():
#	theta = 0
##	prev_pos = get_node("/root/Node/KinematicBody/Camera").get_global_transform().origin
##	globals.desired_pos = get_node("/root/Node/KinematicBody").get_global_transform().origin
#
#func exit():
#	pass
#
#func update(_delta):
#	phi = -globals.mouse_delta.x*0.001
#	var camera = get_node("/root/Node/KinematicBody/Camera")
#	camera.look_at(Vector3(0,0,0), Vector3(0,1,0))
#	t.origin = camera.get_global_transform().origin.normalized()*10
#	t = t.rotated(Vector3(0,1,0), phi)
#	t = t.orthonormalized()
#
#
#	var collision = get_node("/root/Node/KinematicBody/").test_move(t, (phi)*Vector3(0,1,0).cross(t.xform(camera.get_global_transform().origin))*0.1, false)
#	if collision:
#		get_node("/root/Node/KinematicBody").move_and_slide(vel/_delta)
#		print("We collide now")
#	else:
#		new_pos = t.xform(camera.get_global_transform().origin)
#		# velocity from ang.vel: v = w x r
#		vel = (phi)*Vector3(0,1,0).cross(new_pos)
#		get_node("/root/Node/KinematicBody/").transform.origin = t.origin
#
## One frame step debug
##	vel = Vector3(0,1,0)
##	if toggle_boi:
##		get_node("/root/Node/KinematicBody").move_and_slide(vel / _delta)
##		toggle_boi = !toggle_boi
#
##	print(vel)
#	remember_angle += phi
#	debug()
#
#func handle_input(_event):
#	if _event is InputEventMouseMotion:
#		globals.mouse_delta += _event.relative
#
#
#func debug():	
#	globals.write_label("Key1", "cam_pos:")
#	globals.write_label("Value1", str(get_node("/root/Node/KinematicBody/Camera").get_global_transform().origin))
#	globals.write_label("Key2", "distance:")
##	globals.write_label("Value2", str(globals.desired_pos))
#	globals.write_label("Value2", str(get_node("/root/Node/KinematicBody/Camera").get_global_transform().origin.distance_to(Vector3(0,0,0))))
#	globals.write_label("Key3", "vel:")
#	globals.write_label("Value3", str(vel))
#
##	globals.write_label("Key1", "x: ")
##	globals.write_label("Value1", str(globals.t.basis.x))
##	globals.write_label("Key2", "y: ")
##	globals.write_label("Value2", str(globals.t.basis.y))
##	globals.write_label("Key3", "z: ")
##	globals.write_label("Value3", str(globals.t.basis.z))
##	globals.write_label("Key4", "o: ")
##	globals.write_label("Value4", str(globals.t.origin))
