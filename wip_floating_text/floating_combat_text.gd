extends Node2D

@export var float_speed: float = 50.0
@export var fade_time: float = 0.8
@onready var label: Label = $Label

func display(value: int, world_position: Vector3):
	var camera : Camera3D = get_viewport().get_camera_3d()

	global_position = camera.unproject_position(world_position)

	label.text = str(value)

	var tween := create_tween().set_parallel()
	tween.tween_property(self, "position:y", position.y - 50.0, fade_time)
	tween.tween_property(label, "modulate:a", 0.0, fade_time)
	tween.tween_callback(queue_free)
