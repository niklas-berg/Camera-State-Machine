extends Node


var mouse_delta: Vector2
var vel: Vector3
var desired_pos: Vector3

func _ready():
	pass

func write_label(label, content):
	get_node("/root/Node/Debug").get_node(label).set_text(content)
	
func _process(delta):
#	mouse_delta = Vector2(0,0)
#	vel = Vector3(0,0,0)
	pass
