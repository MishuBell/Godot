extends Node
## This controls the camera!!
##
## script: camera_control.gd
@onready var camera : Camera3D = $"../Camera3D"
@onready var character : CharacterBody3D = $".."

@export var sensitivity : float
var rotation_x : float = 0.0
var delta_time : float

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	delta_time = delta

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look(event, delta_time)

func look(event: InputEvent, delta : float) -> void:

	var rotation_change_y = (-event.relative.x * 0.01) * sensitivity * delta
	var rotation_change_x = (event.relative.y * 0.01) * sensitivity * delta

	character.rotate_y(rotation_change_y)

	rotation_x = clamp(rotation_x - rotation_change_x, -1.5, 1.5)
	camera.rotation_degrees.x = rad_to_deg(rotation_x)
# ===== END =====
