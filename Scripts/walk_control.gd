extends Node
## This is the movement script for WASD movement
##
## script: walk_control.gd

@onready var player : CharacterBody3D = $".."
@export var speed : float = 5.0


func _physics_process(delta: float) -> void:
	move(delta)

func move(delta):
	var direction = Vector3()

	if Input.is_action_pressed("w"):
		direction -= player.transform.basis.z * delta
	if Input.is_action_pressed("s"):
		direction += player.transform.basis.z * delta
	if Input.is_action_pressed("a"):
		direction -= player.transform.basis.x * delta
	if Input.is_action_pressed("d"):
		direction += player.transform.basis.x * delta

	direction = direction.normalized()
	player.velocity.x = direction.x * speed #TODO: Do we also multiply with Delta here?
	player.velocity.z = direction.z * speed

	player.move_and_slide()
# ========= END ==========
