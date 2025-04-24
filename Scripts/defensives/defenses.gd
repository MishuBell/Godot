# ========== defenses.gd ========== #
extends Area3D

@export_group("Defensive Variables")
@export var has_resistance : bool
@export var resistance : float
@export var has_armor : bool
@export var armor : int

@export var has_shield : bool
@export var shield : float

@export var has_health : bool
@export var health : float
@export_group("")

@export var next_defensive : Node


func take_damage(damage_amount: DamagePackage):
	next_defensive.take_damage(damage_amount)
