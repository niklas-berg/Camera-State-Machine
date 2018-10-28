extends "Camera_Interface.gd"
#
#var theta = 0.0
#var start_pos = Vector3()
#var end_pos = Vector3()
#
#func enter():
#	theta = 0
#	start_pos = get_node("/root/Node/Camera").get_global_transform().origin #globals.desired_cam_pos
#	end_pos = globals.last_obstacle_position
#	get_node("/root/Node/Debug").get_node("Label2").set_text(str(end_pos))
#	print("Start: ", start_pos, " , End: ", end_pos)
#
#func exit():
#	pass
#
#func handle_input(_event):
#	# Zooming out should not be allowed when camera is zooming in
##	if _event is InputEventMouseMotion and not _event.relative.y < 0:
##		mouse_delta = _event.relative
##		globals.angle_y += mouse_delta.x * globals.SENSITIVITY
##	.handle_input(_event)
#	pass
#
#func update(delta):
#	theta += 0.01
#	theta = clamp(theta, 0, 1)
#	globals.desired_cam_pos = start_pos.linear_interpolate(end_pos, theta)
#
#	globals.camera.look_at_from_position(globals.desired_cam_pos, globals.target.get_global_transform().origin, Vector3(0, 1, 0))
#
#	if theta == 1: #and globals.obstacle.empty():
##		get_node("/root/Node/Debug").get_node("Label3").set_text("Done lerping")
#		emit_signal("finished", "Collision_Position")
##		emit_signal("finished", "Free_Look")
#
#	var space_state = globals.camera.get_world().get_direct_space_state()
#	globals.obstacle = space_state.intersect_ray(globals.target.get_global_transform().origin, globals.camera.get_global_transform().origin)