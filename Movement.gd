extends MeshInstance

var camera: Basis
var prevPos: Vector3
var desiredPos: Vector3
var preA: Vector3
var postB: Vector3
onready var target: Spatial = get_node("/root/Node/Target")

func _ready():
	desiredPos = target.global_transform.origin
	preA = target.global_transform.origin

func _process(delta):
	camera = $"/root/Node/KinematicBody/Camera".global_transform.basis
	
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
	dir = dir.normalized() * 1.0

	var speed = 0.50
	desiredPos += dir * 0.50 * speed
	postB = desiredPos * 1.0 * speed

	preA = target.global_transform.origin

func _physics_process(delta):
#	target.global_transform.origin = target.global_transform.origin.cubic_interpolate(desiredPos, preA, postB, delta * 25.0)
	target.global_transform.origin = desiredPos

	