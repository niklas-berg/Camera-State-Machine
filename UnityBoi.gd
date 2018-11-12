extends Node

onready var camera: Spatial = get_node("/root/Node/KinematicBody/Camera")
onready var target: Spatial = get_node("/root/Node/Target")

var mouseDelta: Vector2
export var mouseSens: float = 1.0
export var damp: float = 5.0
var yaw: float
var pitch: float
var t: float
#var tOut: float
var previousRotation: Quat
var offset: Vector3
var newOffset: Vector3
var ray: RayCast
var _ray: RayCast
var cameraRays: Dictionary

var hit
var occlusion: bool

var desiredCamPos: Vector3
var previousCamPos: Vector3
var finalCamPos: Vector3
var collisionPoint
var wouldCollide: bool # Use KinematicBody to see whether we're sliding along wall or occlusion has occurred
var previousCollisionPoint: Vector3 # Used when zooming out
var previousCollisionLength: float
var newRotation
var previousTargetPos: Vector3

var zoomOut: bool = false
var setOpaque: bool = true

var theta: float = 0.0

func enter():
	
	
#	var out = $"/root/Node/Target" #.get_property_list()
#	print(get_node("/root/Node/Target").get_surface_material(0).set_shader_param("ScalarUniform", 1.0))
#	var out2= get_node_and_resource("/root/Node/Target")
#	var out3 = $"/root/Node/Target".get_surface_material(0).get("shader_param/ScalarUniform")
#	$"/root/Node/Target".get_surface_material(0).set("shader_param/ScalarUniform", 1.0)
#	$"/root/Node/Target".get_surface_material(0).set("shader_param/ScalarUniform", 0.0)
#	print($"/root/Node/Target".get_surface_material(0))
	
	occlusion = false
	ray = RayCast.new()
	target.add_child(ray)
	ray.enabled = true
	ray.set_collision_mask_bit(0, true)
	ray.set_collision_mask_bit(1, false)
	
#	_ray = RayCast.new()
#	target.add_child(_ray)
#	_ray.enabled = true
#	_ray.set_collision_mask_bit(0, true)
#	_ray.set_collision_mask_bit(1, false)
	cameraRays = {'topLeft': RayCast.new(), 'topRight': RayCast.new(), 'bottomLeft': RayCast.new(), 'bottomRight': RayCast.new(), 'center': RayCast.new()}
	for c in cameraRays:
		print("Setting up: ", c, ": ", cameraRays[c])
		target.add_child(cameraRays[c])
		cameraRays[c].enabled = true
		cameraRays[c].set_collision_mask_bit(0, true)
		cameraRays[c].set_collision_mask_bit(1, false)

	previousRotation = Quat(camera.global_transform.basis)
	offset = camera.global_transform.origin - target.global_transform.origin # Should only be set once
	
	# This is uggu, but needed when placing quat calculations in _process().
	# Maybe it's unecessary.
	newRotation = Quat(Basis(Vector3(deg2rad(pitch), deg2rad(yaw), 0)))
	desiredCamPos = target.global_transform.origin + newRotation * offset
	collisionPoint = checkCollision(desiredCamPos)

func exit():
	pass

func _process(_delta):
	previousTargetPos = target.global_transform.origin
	mouseDelta = Vector2(0,0)
	t += _delta * 5.05
	t = clamp(t, 0, 1)

	if(Input.is_action_just_released("toggleFullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen

func cameraControl(_delta):
	newRotation = Quat(Basis(Vector3(deg2rad(pitch), deg2rad(yaw), 0)))
	newRotation = previousRotation.slerp(newRotation, _delta * damp)
	previousRotation = newRotation

	desiredCamPos = target.global_transform.origin + newRotation * offset
#	collisionPoint = checkCollision(desiredCamPos) # Collision length
	var collisionDistance = checkCollision(desiredCamPos)
	if collisionDistance:
		collisionPoint = target.global_transform.origin + ((desiredCamPos - target.global_transform.origin).normalized()) * collisionDistance
	else:
		collisionPoint = null
	# |) A

	if(collisionPoint):
		previousCollisionPoint = collisionPoint
		zoomOut = true
		previousCollisionLength = (collisionPoint - camera.global_transform.origin).length()
		var slightNudge: float = 0.0000001
		# checking behind KinBody
		wouldCollide = $"/root/Node/KinematicBody".test_move(camera.global_transform, (-(target.global_transform.origin - camera.global_transform.origin)).normalized()*slightNudge, false)
		var epsilon = 0.01
		if((camera.global_transform.origin - collisionPoint).length() > epsilon && !wouldCollide):

			if(occlusion == false):
				t = 0
			occlusion = true
			newOffset = offset.normalized() * (t*(target.global_transform.origin - collisionPoint).length() + (1-t)*(target.global_transform.origin - camera.global_transform.origin).length())
			finalCamPos = target.global_transform.origin + newRotation * newOffset
			
			if(t >= 0.9999):
				occlusion = false
		else:
			finalCamPos = collisionPoint
			
	else:
		if zoomOut:
			t = 0
			t = clamp(t, 0, 1)
			previousCollisionLength = (camera.global_transform.origin - target.global_transform.origin).length()
		occlusion = false
		zoomOut = false
		newOffset = offset.normalized() * (t*(offset).length() + (1-t)*previousCollisionLength)
		finalCamPos = target.global_transform.origin + newRotation * newOffset

	camera.global_transform.origin = finalCamPos
	camera.look_at(target.global_transform.origin, Vector3(0, 1, 0))
	debug()
	
	fadeOutTarget()

func fadeOutTarget():
	var d = (camera.global_transform.origin - target.global_transform.origin).length()
	var alpha = (d) / offset.length()
	alpha = clamp(alpha, 0, 1)
	alpha = pow((alpha + 1), 4) - 2
	if alpha < 1.0:
		$"/root/Node/Target".get_surface_material(0).set_shader_param("alphaBoi", alpha)
		setOpaque = true
	elif setOpaque: # Don't want to update shader param each frame, maybe this isn't an issue? :shrug:
		setOpaque = false
		$"/root/Node/Target".get_surface_material(0).set_shader_param("alphaBoi", 1.0)
	

func update(_delta):
	pass
	

func handle_input(_event):
	if _event is InputEventMouseMotion:
		mouseDelta = _event.relative
	yaw -= mouseDelta.x * mouseSens
	pitch += mouseDelta.y * mouseSens
	pitch = clamp(pitch, -30, 30)

func checkCollision(desired_cam_pos: Vector3):
	
	# Casting rays to viewport's corners
	# --- go back to collision checker
	var z = camera.near
	var x = z * tan(deg2rad(camera.fov/2)) * 30
	var aspectRatio = get_viewport().size.x / get_viewport().size.y
	var y = x / aspectRatio
	
	
	var topLeft = (desired_cam_pos + camera.global_transform.basis * Vector3(-x,y,z))
	var topRight = (desired_cam_pos + camera.global_transform.basis * Vector3(x,y,z))
	var bottomLeft = (desired_cam_pos + camera.global_transform.basis * Vector3(-x,-y,z))
	var bottomRight = (desired_cam_pos + camera.global_transform.basis * Vector3(x,-y,z))
	
#	theta += _delta * 4
#	$"/root/Node/SmolCube".global_transform.origin = (1-sin(theta))*bottomRight + sin(theta) * target.global_transform.origin
	# --- 
	
	for c in cameraRays:
		cameraRays[c].force_raycast_update()
	
	var nudge = 1.0
	cameraRays['topLeft'].cast_to = -(target.global_transform.origin - topLeft) * nudge
	cameraRays['topRight'].cast_to = -(target.global_transform.origin - topRight) * nudge
	cameraRays['bottomLeft'].cast_to = -(target.global_transform.origin - bottomLeft) * nudge
	cameraRays['bottomRight'].cast_to = -(target.global_transform.origin - bottomRight) * nudge
	cameraRays['center'].cast_to = -(target.global_transform.origin - desired_cam_pos) * nudge
	
	var d: float = -1
	var hit: Vector3
	var name: String
	for c in cameraRays:
		var collider = cameraRays[c].get_collider()
		if(collider):
			var _hit = cameraRays[c].get_collision_point()
			var _d = (_hit - target.global_transform.origin ).length()
			if (d < 0) or (_d < d):
				d = _d
				hit = _hit
				name = c

	if d < 0:
		return null
	else:
#		print(name)
		return d
#		return d * desiredCamPos.normalized()
#		return hit

	# --- 
#	ray.force_raycast_update()
#	ray.cast_to = -(target.global_transform.origin - desired_cam_pos)
#	hit = ray.get_collision_point()
#	var collider = ray.get_collider()
#
#	if collider:
#		print("Center boi: ", (target.global_transform.origin - hit).length())
#		return hit
#
#	return null

func checkOcclusion(collisionPoint):
	pass

func write_label(label, content):
	get_node("/root/Node/Debug").get_node(label).set_text(content)
	
func debug():	
	write_label("Key1", "collision: ")
	write_label("Value1", str(hit))
#	write_label("Key2", "distance:")
#	write_label("Value2", str(get_node("/root/Node/KinematicBody/Camera").get_global_transform().origin.distance_to(target.global_transform.origin)))
	write_label("Key2", "cam pos:")
	write_label("Value2", str(camera.global_transform.origin))
	write_label("Key3", "distance:")
	write_label("Value3", str( (camera.global_transform.origin - target.global_transform.origin).length() ))
#	Line.new()

	get_node("/root/Node/FpsPanel").get_node("FpsLabel").set_text(str(Engine.get_frames_per_second()))
