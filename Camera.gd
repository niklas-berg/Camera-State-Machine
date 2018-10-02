extends Camera

var timer = 0.0
var lock_input = false
onready var pivot = get_node("../Mavis")
# Mouse control
var mouse_position = Vector2(0.0, 0.0)
var cam_pos = Vector3()
var zoom = 0.0
var rotate_y = 0.0
# Linear interpolation
var lerping = false # Set linear motion to and from collision position
var theta = 0	# lerp parameter
var start_pos = Vector3() 	# end_pos will either be collision pos. or cam_pos depending on
var end_pos = Vector3() 	# whether we're moving in or out of a collision
var last_collision_point = Vector3()	# Needs to be stored when moving out of collision, unlike cam_pos which is always 
										# calculated from input and kept in the A-block below
# -----------------------------------------------------------------------------------------------
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.relative

func _physics_process(delta):
	timer += 0.001
	# Check for different states here
	# if mouse_mode == 'mouselook': # You get the idea
	_update_mouselook(delta)

# Calculates desired camera position
func position_from_input(coll_pos=null):
	var r = 5
	if coll_pos:
		var new_zoom = sqrt(pow(get_global_transform().origin.x, 2) + pow(get_global_transform().origin.z, 2)) / r
		if new_zoom >= 0.5 and new_zoom <= PI/2:
			zoom = new_zoom
			zoom = clamp(zoom, 0.5, PI/2)
			print("zoom: ", zoom, ", cam distance: ", get_global_transform().origin.distance_to(pivot.get_global_transform().origin))
		else:
			# Camera collisioned to move closer than mininum distance.
			pass
	else:
		# Read input
		var damp = 0.01
		zoom += mouse_position.y * damp
		zoom = clamp(zoom, 0.5, PI/2)	# Lower limit prevents from zooming to mesh origin
		rotate_y += mouse_position.x * damp
	
	# Update camera position
	cam_pos = self.get_global_transform().origin
	cam_pos.y = zoom*sin(zoom)*5 + 5
	
	# Location on the ZX-plane
													# TODO: r, zoom, and length between obstacle and target 
	r *= zoom
	cam_pos.z = cos(rotate_y) * r					#	should be mapped to each other in order for pitch tilt
	cam_pos.x = -sin(rotate_y) * r 					# to follow along.

func _update_mouselook(delta):
	if not lock_input:
		position_from_input()
	# Collision detection
	var space_state = get_world().get_direct_space_state()
	var ray_offset = Vector3(0,3,0)	# Ray shouldn't cross origin (i.e. the feet of the character).
									# TODO: ray_offset should depend on target node's Mesh.
	var obstacle = space_state.intersect_ray(pivot.get_global_transform().origin + ray_offset, cam_pos)
	
	
	# Linear interpolated movement between camera and collision object
	var speed = 5
	start_pos = cam_pos
	if not obstacle.empty():
		end_pos = obstacle.position
		theta += delta*speed
		theta = clamp(theta, 0, 1)
		last_collision_point = end_pos # Store collision point for zooming back
		if mouse_position.y < 0:
			position_from_input(last_collision_point)
		else:
			lock_input = true
			print(zoom)
	else:
		end_pos = last_collision_point
		theta -= delta*speed
		theta = clamp(theta, 0, 1)
		lock_input = false
	
	var _pos = start_pos.linear_interpolate(end_pos, theta)
	cam_pos = _pos

	# Change tilt depending on camera distance; looks up a bit when zoomed in
	var pitch_offset = pivot.get_global_transform().origin - cam_pos	# Camera aim
#	if not theta == 0 and not theta == 1:
#		zoom = theta*PI/2
#		zoom = clamp(zoom, 0.5, PI/2)
#	else:
	pitch_offset.y = 19/sqrt(pow(cam_pos.x, 2) + pow(cam_pos.z, 2))

#	pitch_offset.y = (10 - sqrt(pow(cam_pos.x, 2) + pow(cam_pos.z, 2) )) # Max-value (to keep this from becoming negative) should be calc.d from XZ-circle's r
	# zoom must be saved and updated to be able to start zooming when camera is backed against wall
#	print(pitch_offset.y)
	

	look_at_from_position(cam_pos, pivot.get_global_transform().origin + pitch_offset, Vector3(0, 1, 0))
	mouse_position = Vector2(0,0)
	
	
