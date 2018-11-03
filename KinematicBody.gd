extends KinematicBody

var velocity: Vector3
var useKinematics: bool = false

func _ready():
	velocity = Vector3(0,0,0)

func _process(delta):
#	velocity = get_node("/root/Node/KinematicBody/Camera/States/UnityBoi").vel
	pass

func _physics_process(delta):
	if useKinematics:
		move_and_slide(velocity)

	
func move(vel):
#	move_and_slide(velocity)
	pass