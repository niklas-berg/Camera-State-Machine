extends Node

onready var camera = get_node("/root/Node/Camera")
onready var target = get_node("/root/Node/Mavis")

var SENSITIVITY = 0.005
var DISTANCE = 10.0
var HEIGHT = 10.0
var LERP_SPEED = 0.5

var cam_pos = Vector3()
var angle_y = 0.0

func _ready():
	cam_pos.z = cos(angle_y) * DISTANCE
	cam_pos.x = -sin(angle_y) * DISTANCE
