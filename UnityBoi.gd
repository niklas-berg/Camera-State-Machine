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


func enter():
	ray = RayCast.new()
	target.add_child(ray)
#	camera.add_child(ray)
#	$"/root/Node/KinematicBody".add_child(ray)
	ray.enabled = true
	ray.set_collision_mask_bit(0, true)
	
	previousRotation = Quat(camera.global_transform.basis)
	offset = camera.global_transform.origin - target.global_transform.origin

func exit():
	pass

func _process(_delta):
	mouseDelta = Vector2(0,0)

func update(_delta):
	yaw -= mouseDelta.x * mouseSens
	pitch += mouseDelta.y * mouseSens
	pitch = clamp(pitch, -30, 30)

	var newRotation = Quat(Basis(Vector3(deg2rad(pitch), deg2rad(yaw), 0)))
	newRotation = previousRotation.slerp(newRotation, _delta * damp)
	previousRotation = newRotation
	
	camera.global_transform.origin = target.global_transform.origin + newRotation * offset
	camera.look_at(target.global_transform.origin, Vector3(0, 1, 0))

	check_collision()
	debug()

func handle_input(_event):
	if _event is InputEventMouseMotion:
		mouseDelta = _event.relative
#		print(mouseDelta)

func check_collision():
	
	ray.force_raycast_update()
	ray.cast_to = -(target.global_transform.origin - camera.global_transform.origin)
	hit = ray.get_collision_point()
	if(hit == Vector3(0,0,0)):
		write_label("Value1", "None")


func write_label(label, content):
	get_node("/root/Node/Debug").get_node(label).set_text(content)
	
func debug():	
	write_label("Key1", "collision: ")
	write_label("Value1", str(hit))
#	write_label("Key2", "distance:")
#	write_label("Value2", str(get_node("/root/Node/KinematicBody/Camera").get_global_transform().origin.distance_to(target.global_transform.origin)))
	write_label("Key2", "cam pos:")
	write_label("Value2", str(camera.global_transform.origin))
	write_label("Key3", "ray pos:")
	write_label("Value3", str(ray.global_transform.origin))

#	Line.new()
