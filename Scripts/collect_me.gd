extends Area3D

@export var animation : AnimationPlayer

func _ready() -> void:
	animation.play("bounce")

func release_me():
	queue_free()
