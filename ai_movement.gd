extends CharacterBody3D

@onready var ai: Area3D = $AI


@export var speed : float

func _process(delta: float) -> void:
	move()
	pass

func move():
	if ai.player:
		var to_player = ai.player.global_position - global_position
		var distance = to_player.length()
		if distance > 10.0:
			var direction = to_player #.normalized()
			velocity = direction * speed
		else:
			velocity = Vector3.ZERO
		move_and_slide()
