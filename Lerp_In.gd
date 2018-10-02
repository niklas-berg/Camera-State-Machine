extends "Camera_Interface.gd"

func handle_input(event):
	if Input.is_action_just_pressed("ui_up"):
		print("We Lerp In now!")
		