# ========= shoot_bullet.gd ============ #
extends Node

#TODO: Gather the bullets somewhere
var gun : res_WeaponData = null
var type : String = String()
#region Built-in functions

func _ready() -> void:
	find_gun()

func _process(delta: float) -> void:
	check_mode()
	pass
#endregion

#region User functions
func find_gun() -> void:
	var guns : Array = get_tree().get_nodes_in_group("gun")
	if guns.size() > 0:
		gun = guns[0]
		guns[1].visible = false
		print("Found gun", gun.name)
	else:
		print("Couldnt find gun")

func check_mode() -> void:
	if gun.mode == "automatic":
		if Input.is_action_pressed("left_click"):
			gun.operate_gun()
	if gun.type == "single":
		if Input.is_action_just_pressed("left_click"):
			gun.operate_gun()
#endregion
