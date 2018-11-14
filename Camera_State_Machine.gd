extends Camera
#
#var states_stack = []
#var current_state
#onready var states_map = {
#	"Free_Look": $States/Free_Look,
#	"Lerp_In": $States/Lerp_In,
#	"Lerp_Out": $States/Lerp_Out,
#	"Collision_Position": $States/Collision_Position,
#	"Slide_Boi": $States/Slide_Boi,
#	"UnityBoi": $States/UnityBoi
#}
#
#func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	# When each state transitions to the next on (is finished)
#	# a signal to _change_state() is called.
#	for state_node in $States.get_children():
#		state_node.connect("finished", self, "_change_state")
##	states_stack.push_front(states_map["Free_Look"])
#	states_stack.push_front(states_map["UnityBoi"])
#	current_state = states_stack[0]
##	_change_state("Free_Look")
#	_change_state("UnityBoi")
#
#func _physics_process(delta):
##	current_state.update(delta)
#	_debug()
#
#func _process(delta):
#	current_state.update(delta)
##	pass
#
#
#func _input(event):
#	current_state.handle_input(event)
#
#func _change_state(state_name):
#	current_state.exit()	# Clean up if necessary
##	print("State machine's received signal: ", state_name)
#	states_stack.push_front(states_map[state_name])
#	current_state = states_stack[0]
#	current_state.enter()	# Initialize if necessary
#
#func _debug():
#	get_node("/root/Node/Debug").get_node("Cam_State").set_text(states_stack[0].name)

	