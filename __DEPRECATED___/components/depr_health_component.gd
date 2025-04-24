# ========= health_component.gd ============ #
extends Node
class_name Health

#region Health variables
@export_category("Health")
@export var base_health: float = 250
@export var max_health: float
@onready var current_health: float = base_health
#endregion

#region Other variables
# Values for the calculation
var current_damage: float = 0
@onready var health_regen_tickrate: Timer = $"Health Regen Tickrate"
@export var health_regen_value : float
#endregion

#region Built-in functions
func _exit_tree() -> void:
	health_regen_tickrate.stop()
#endregion

#region User functions
func accept_remainder(damage_package: DamagePackage) -> void:
	current_damage = damage_package.damage_remainder
	take_damage()
	pass

func take_damage() -> void:
	current_health -= current_damage
	#print("Incoming: ", current_damage, " Health: ", current_health, "/", max_health)
	#report_to_console()
	health_regen()

func take_pure_damage(damage_package: DamagePackage) -> void:
	current_health -= damage_package.damage_value
	#report_to_console()
	health_regen()

func health_regen() -> void:
	while current_health < max_health:
		health_regen_tickrate.start()
		current_health += health_regen_value
		#print("Health regenerated: ", current_health, "/", max_health)

		await health_regen_tickrate.timeout
		if current_health >= max_health:
			current_health = max_health
			break
	health_regen_tickrate.stop()

#func report_to_console() -> void:
	#print("Health: ", current_health, "/", base_health)
##endregion
