extends AnimationPlayer

@export var weapon_data : res_WeaponData

func start() -> void:
	play(weapon_data.animation)
