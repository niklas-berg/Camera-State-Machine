extends Node

signal finished(next_state_name)


onready var globals = get_node("/root/Node/Camera/States")
var mouse_delta = Vector2()

var obstacle = null
var last_obstacle_position = Vector3()

#func _ready():
#	pass

func enter():
	pass

func exit():
	pass
	
func update(delta):
	var space_state = globals.camera.get_world().get_direct_space_state()
	obstacle = space_state.intersect_ray(globals.target.get_global_transform().origin, globals.cam_pos)
	globals.camera.look_at_from_position(globals.cam_pos, globals.target.get_global_transform().origin, Vector3(0, 1, 0))
	
func handle_input(_event):
#	print(mouse_delta)
	globals.cam_pos.z = cos(globals.angle_y) * 10
	globals.cam_pos.x = -sin(globals.angle_y) * 10

