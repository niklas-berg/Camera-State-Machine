extends "Camera_Interface.gd"
##onready var globals = get_node("../States")
#
#func enter():
#	pass
#
#func exit():
#	print("Exit")
#
#func handle_input(_event):
#	if _event is InputEventMouseMotion:
#		mouse_delta = _event.relative
#		globals.angle_y += mouse_delta.x * globals.SENSITIVITY
#	globals.desired_cam_pos.z = cos(globals.angle_y) * 10
#	globals.desired_cam_pos.x = -sin(globals.angle_y) * 10
#
#func update(delta):
#	var space_state = globals.camera.get_world().get_direct_space_state()
##	var space_state = get_node("/root/Node/KinematicBody/Camera").get_world().get_direct_space_state()
#	globals.obstacle = space_state.intersect_ray(globals.target.get_global_transform().origin, globals.desired_cam_pos)
#	if not globals.obstacle.empty():
#		globals.last_obstacle_position = globals.obstacle.position
#		emit_signal("finished", "Lerp_In")
##		globals.camera.look_at_from_position(globals.obstacle.position, globals.target.get_global_transform().origin, Vector3(0, 1, 0))
#	else:
#		globals.camera.look_at_from_position(globals.desired_cam_pos, globals.target.get_global_transform().origin, Vector3(0, 1, 0))