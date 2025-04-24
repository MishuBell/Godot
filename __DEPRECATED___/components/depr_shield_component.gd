# ========= shield_component.gd ============ #
class_name ShieldComponent extends Node
#region TODO:
# - The shield value updates every tickrate, which is leading to the shield having an amount > max_shield for the tickrate_waittime
# Shieldregen happens on timer timeout. Its fine but it sucks?
#endregion


#region Absorbtions variables
@export_category("Absorbtions")
@export var shield: float
@onready var max_shield: float = shield
@export var shield_regen_amount : float
# Timers
@onready var shield_regen_delay: Timer = $"Shield Regen Delay"
@onready var shield_regen_tickrate: Timer = $"Shield Regen Tickrate"

@onready var health_component: Health = $"../Health Component"
#endregion


#region User functions
func take_damage(damage_package : DamagePackage) -> void:
	shield -= damage_package.damage_value
	if shield < 0.0:
		var remainder = abs(shield)
		# Why do i make another variable
		damage_package.damage_remainder = remainder
		shield = 0.0
		if health_component.has_method("accept_remainder"):
			health_component.accept_remainder(damage_package)
	shield_regen_delay.start()
	#report_to_console()


func regen_shield() -> void:
	while shield < max_shield and shield_regen_delay.is_stopped():
		shield_regen_tickrate.start()
		shield += shield_regen_amount
		#print("Shield generated: ", shield, "/", max_shield)

		await shield_regen_tickrate.timeout

		if shield >= max_shield:
			shield = max_shield
			break
	# It is set on autostart. But just to be sure 🚑
	shield_regen_tickrate.stop()

func _on_shield_regen_delay_timeout() -> void:
	print("The timer run out and i started regenerating shields!")
	regen_shield()

func _exit_tree() -> void:
	shield_regen_tickrate.stop()
	shield_regen_delay.stop()

#func report_to_console() -> void:
	#if shield > 0:
		#print("Shield: ", shield, "/", max_shield)
#endregion
