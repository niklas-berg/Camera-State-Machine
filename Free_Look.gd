extends "Camera_Interface.gd"
#onready var globals = get_node("../States")

func enter():
	pass
	
func exit():
	pass

func handle_input(_event):
	if _event is InputEventMouseMotion:
		mouse_delta = _event.relative
	globals.angle_y += mouse_delta.x * globals.SENSITIVITY
	.handle_input(_event)

func update(delta):

	.update(delta)
	if not obstacle.empty():
		last_obstacle_position = obstacle.position
		print(last_obstacle_position)
		emit_signal("finished", "Lerp_In")
	