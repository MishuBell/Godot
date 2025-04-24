# ========== shield.gd ========== #
extends Node

@export var defensive_parent : Node
@export var next_defensive : Node

var shield_available : bool = false

func take_damage(damage_amount: DamagePackage):
	if shield_available == false:
		next_defensive.take_damage(damage_amount)
#
	#if defensive_parent.shield > 0.0:
		#defensive_parent.shield -= damage_amount.damage_value
		#shield_available = true
##
	#if defensive_parent.shield <= 0.0:
		#shield_available = false
		#var remainder = abs(defensive_parent.shield)
		#damage_amount.damage_value = remainder
		##print("------> Entering: ", self.name)
		#next_defensive.take_damage(damage_amount)
		##print("<------- Exiting: ", self.name)
