# ========== health.gd ========== #
extends Node

@export var defensive_parent : Node
var called_dam_on_h : int = 0

func take_damage(damage_amount: DamagePackage):
	called_dam_on_h += 1
	defensive_parent.health -= damage_amount.damage_value
	print("Called DMG on H: ", called_dam_on_h)
