# ========== floating_combat_text.gd ========== #
extends Node3D

@onready var shield_component: ShieldComponent = $"../Hurtbox/Defensives/Shield Component" as ShieldComponent
@onready var label_3d: Label3D = $Label3D

func _process(delta: float) -> void:
	label_3d.text = str("Shield ", shield_component.shield)
