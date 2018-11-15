extends MeshInstance

var camera: Basis
var prevPos
var desiredPos
var dir
var t = 0
var vel: Vector3

func _ready():
	desiredPos = global_transform.origin
	prevPos = global_transform.origin
	
func _input(event):
	
	if(Input.is_action_just_released("toggleFullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen
	
func _process(delta):
	pass
#	boi(delta)
func _physics_process(delta):
#	pass
	boi(delta)
func boi(delta):
	dir = Vector3(0,0,0)
	camera = $"/root/Node/KinematicBody/Camera".global_transform.basis
	t += delta * 2
	
	if(Input.is_action_pressed("ui_up")):
		dir -= camera[2] # Vector3(0,0,1) 
	if(Input.is_action_pressed("ui_down")):
		dir += camera[2] # Vector3(0,0,1)
	if(Input.is_action_pressed("ui_left")):
		dir += -camera[0] # Vector3(1,0,0)
	if(Input.is_action_pressed("ui_right")):
		dir -= -camera[0] # Vector3(1,0,0)
	if(Input.is_action_pressed("jump")):
		dir += Vector3(0,1,0)
	if(Input.is_action_pressed("crouch")):
		dir -= Vector3(0,1,0)
	dir = dir.normalized() * 1.0

	var speed = 10.250
	desiredPos += dir * speed * delta
#	desiredPos = Vector3(-5+5*cos(t), 0, sin(t))
	vel = desiredPos - prevPos
	
	global_transform.origin = desiredPos
	translate(vel * delta)
	
	prevPos = global_transform.origin
	$"/root/Node/KinematicBody/Camera/States/UnityBoi".cameraControl(delta)
	
	
