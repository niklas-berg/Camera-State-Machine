extends Node

onready var camera: Spatial = get_node("/root/Node/KinematicBody/Camera")
onready var target: Spatial = get_node("/root/Node/Target")

var mouseDelta: Vector2
export var mouseSens: float = 1.0
export var damp: float = 5.0
var yaw: float
var pitch: float
var t: float
var previousRotation: Quat
var offset: Vector3
var ray: RayCast
var hit
var colliding: bool

var desiredCamPos
var collisionPoint
var newRotation


func enter():
	colliding = false
	ray = RayCast.new()
	target.add_child(ray)
	ray.enabled = true
	ray.set_collision_mask_bit(0, true)
	ray.set_collision_mask_bit(1, false)
	
	previousRotation = Quat(camera.global_transform.basis)
	offset = camera.global_transform.origin - target.global_transform.origin
	
	# This is uggu, but needed when placing quat calculations in _process().
	# Maybe it's unecessary.
	newRotation = Quat(Basis(Vector3(deg2rad(pitch), deg2rad(yaw), 0)))
	desiredCamPos = target.global_transform.origin + newRotation * offset
	collisionPoint = check_collision(desiredCamPos)

func exit():
	pass

func _process(_delta):
	mouseDelta = Vector2(0,0)
	# |> A
	newRotation = Quat(Basis(Vector3(deg2rad(pitch), deg2rad(yaw), 0)))
	newRotation = previousRotation.slerp(newRotation, _delta * damp)
	previousRotation = newRotation
	desiredCamPos = target.global_transform.origin + newRotation * offset
	collisionPoint = check_collision(desiredCamPos)
	# |) A
func update(_delta):

	# |< A

	if(collisionPoint):
		colliding = true
		camera.global_transform.origin = collisionPoint
#		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(collisionPoint, _delta * 25)
	else:
		colliding = false
		camera.global_transform.origin = desiredCamPos
#		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(desired_cam_pos, _delta * 5)

	camera.look_at(target.global_transform.origin, Vector3(0, 1, 0))

	debug()

func handle_input(_event):
	if _event is InputEventMouseMotion:
		mouseDelta = _event.relative
	yaw -= mouseDelta.x * mouseSens
	pitch += mouseDelta.y * mouseSens
	pitch = clamp(pitch, -30, 30)

func check_collision(desired_cam_pos: Vector3):
	
	ray.force_raycast_update()
	ray.cast_to = -(target.global_transform.origin - desired_cam_pos)
	hit = ray.get_collision_point()
	write_label("Key3", "ray collision:")
	var collider = ray.get_collider()
	write_label("Value3", str(collider))

	if collider:
		return hit
	else:
		return null
	

func write_label(label, content):
	get_node("/root/Node/Debug").get_node(label).set_text(content)
	
func debug():	
	write_label("Key1", "collision: ")
	write_label("Value1", str(hit))
#	write_label("Key2", "distance:")
#	write_label("Value2", str(get_node("/root/Node/KinematicBody/Camera").get_global_transform().origin.distance_to(target.global_transform.origin)))
	write_label("Key2", "cam pos:")
	write_label("Value2", str(camera.global_transform.origin))
#	write_label("Key3", "ray pos:")
#	write_label("Value3", str(ray.global_transform.origin))

#	Line.new()
