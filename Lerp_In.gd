extends "Camera_Interface.gd"

var theta = 0.0
var start_pos = Vector3()
var end_pos = Vector3()

func enter():
	start_pos = globals.cam_pos
	end_pos = last_obstacle_position
	print(start_pos)

func exit():
	pass

func handle_input(_event):
	# Zooming out should not be allowed when camera is zooming in
	if _event is InputEventMouseMotion and not _event.relative.y < 0:
		mouse_delta = _event.relative
	.handle_input(_event)

func update(delta):
	theta += 0.01
	theta = clamp(theta, 0, 1)
	globals.cam_pos = start_pos.linear_interpolate(end_pos, theta)
	.update(delta)