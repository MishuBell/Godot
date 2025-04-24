extends Node3D

@export var health_component: Health
@onready var health_bar: MeshInstance3D = $"."



func _ready():
	update_health_bar()  # Set initial scale

func update_health_bar():
	if health_component:
		var scale_x = health_component.current_health / health_component.max_health
		health_bar.scale.x = clamp(scale_x, 0.0, 1.0)

func _process(delta):
	update_health_bar()  # Continuously sync with health
