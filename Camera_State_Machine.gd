extends Camera

var states_stack = []
var current_state
onready var states_map = {
	"Free_Look": $States/Free_Look,
	"Lerp_In": $States/Lerp_In,
	"Lerp_Out": $States/Lerp_Out,
	"Collision_Position": $States/Collision_Position
}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# When each state transitions to the next on (is finished)
	# a signal to _change_state() is called.
	for state_node in $States.get_children():
		state_node.connect("finished", self, "_change_state")
	states_stack.push_front(states_map["Free_Look"])
	current_state = states_stack[0]
	_change_state("Free_Look")

func _physics_process(delta):
	current_state.update(delta)
	_debug()

func _input(event):
	current_state.handle_input(event)

func _change_state(state_name):
	current_state.exit()	# Clean up if necessary
	states_stack.push_front(states_map[state_name])
	current_state = states_stack[0]
	current_state.enter()	# Initialize if necessary
	
func _debug():
	get_node("../Debug").get_node("Cam_State").set_text(states_stack[0].name)

	