# ========== armor.gd ========== #
extends Node

@export var defensive_parent : Node3D
@export var next_defensive : Node

func take_damage(damage_amount: DamagePackage):
	if defensive_parent.armor > 0:
		print("fuck off")
		defensive_parent.armor -= 1
		damage_amount.damage_value = 0.0
		next_defensive.take_damage(damage_amount)
	if defensive_parent.armor <= 0:
		next_defensive.take_damage(damage_amount)
