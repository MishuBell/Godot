extends Node

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("escape"):
		get_tree().quit()
	if Input.is_action_just_pressed("f"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("q"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
