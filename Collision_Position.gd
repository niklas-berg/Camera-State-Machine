extends "Camera_Interface.gd"
#
#
#
#func _ready():
#	pass
#
#func enter():
#	var cam_pos = globals.camera.get_global_transform().origin
#	var target = globals.target.get_global_transform().origin
##	print("cam_pos: ", cam_pos, "	target: ", target, "	projection: ", Vector3(1, 0, 0).dot(cam_pos), "	distance: ", cam_pos.distance_to(target))
##	globals.angle_y = rad2deg(acos(Vector3(1, 0, 0).dot(cam_pos) / cam_pos.distance_to(target)))
#	globals.DISTANCE = cam_pos.distance_to(target)
#
#	print(globals.angle_y)
#
#func handle_input(event):
#	if event is InputEventMouseMotion: #and not event.relative.y < 0:
#		mouse_delta = event.relative
#		globals.angle_y += mouse_delta.x * globals.SENSITIVITY
#	globals.desired_cam_pos.z = cos(globals.angle_y) * globals.DISTANCE
#	globals.desired_cam_pos.x = -sin(globals.angle_y) * globals.DISTANCE
#
#func update(delta):
#	globals.camera.look_at_from_position(globals.desired_cam_pos, globals.target.get_global_transform().origin, Vector3(0, 1, 0))