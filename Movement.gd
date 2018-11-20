#extends MeshInstance
extends KinematicBody

var camera: Basis
var prevPos
var desiredPos
var dir: Vector3 = Vector3(0,0,0)
var t = 0
var vel: Vector3 = Vector3(0,0,0)
var SPEED = 10.250

func _ready():
	desiredPos = global_transform.origin
	prevPos = global_transform.origin
	
func _input(event):
	
	if(Input.is_action_just_released("toggleFullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen
	
	camera = $"/root/Node/KinematicBody/Camera".global_transform.basis
	dir = Vector3(0,0,0)
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
	dir = dir.normalized() * SPEED
	
func _process(delta):
	pass
#	boi(delta)
func _physics_process(delta):
#	pass
	boi(delta)

func boi(delta):
	
	
	
#	desiredPos += dir * speed * delta
#	vel = desiredPos - prevPos
	
#	global_transform.origin = desiredPos
#	translate(vel * delta)
	vel += dir
	vel = move_and_slide(dir)
	
	prevPos = global_transform.origin
	$"/root/Node/KinematicBody/Camera/States/UnityBoi".cameraControl(delta)
	
	
