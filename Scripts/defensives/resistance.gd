# ========== resistance.gd ========== #
extends Node

@export var defensive_parent : Node
@export var next_defensive : Node

func take_damage(damage_amount: DamagePackage):
	next_defensive.take_damage(damage_amount)
