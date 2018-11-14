extends MeshInstance

var camera: Basis
var prevPos: Vector3
var desiredPos: Vector3
var preA: Vector3
var postB: Vector3
var dir: Vector3
onready var target: Spatial = get_node("/root/Node/Target")

var vel: Vector3

func _ready():
	desiredPos = target.global_transform.origin
	preA = target.global_transform.origin
	prevPos = global_transform.origin
	
func _input(event):
	if(Input.is_action_just_released("toggleFullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen

	
func _process(delta):
	pass

func _physics_process(delta):
	camera = $"/root/Node/KinematicBody/Camera".global_transform.basis
	dir = Vector3(0,0,0)
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

	var speed = 0.250
	desiredPos += dir * 10.50 * speed * delta
	vel = desiredPos - prevPos
	
	translate(vel * delta)
#	global_transform.origin = desiredPos
	prevPos = global_transform.origin
#	$"/root/Node/KinematicBody/Camera/States/UnityBoi".cameraControl(delta)
	