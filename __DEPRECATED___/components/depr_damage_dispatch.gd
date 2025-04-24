# ========= damage_dispatch.gd ============ #
extends Node

# See notes below for explanations
#region TODO:
# (Resource approach) Refactor this into resources, rather than nodes for shield/health and a manager (defensives)
#
#endregion
@export_group("Properties")
@export var shield_activated : bool
@export var health_activated : bool
@export_group("")

#region Variables
@onready var health: Health = null
@onready var shield: ShieldComponent = null

@export var health_comp : Health

var current_damage_package : DamagePackage = null

var shield_available : bool
var health_available : bool
#endregion


#region Prepare
func _ready() -> void:
	find_shield()
	find_health()
	pass

func find_shield() -> void:
	for child in get_children():
		# "Is this Node an instance of the Shield class (or a subclass)?"
		if child is ShieldComponent:
			shield = child
			shield_available = true
			#warn_for_unset_shield()
			break
		else:
			shield_available = false

#func warn_for_unset_shield() -> void:
	#if shield.shield <= 0.0:
		#print("Shield variable not set!")

func find_health() -> void:
	for child in get_children():
		# "Is this Node an instance of the Shield class (or a subclass)?"
		if child is Health:
			health = child
			health_available = true
			#warn_for_unset_health()
			break
		else:
			health_available = false

#func warn_for_unset_health() -> void:
	#if health.current_health <= 0.0:
		#print("Health variable not set!")
#endregion


#region Manage Damage
func _process(_delta: float) -> void:
	death()


func accept_damage(damage_package : DamagePackage) -> void:
	current_damage_package = damage_package
	dispatch_damage()


func dispatch_damage() -> void:
	if shield_available and shield_activated:
		propagate_to_shield()
	elif health_available and health_activated:
		propagate_to_health()


func propagate_to_shield() -> void:
	shield.take_damage(current_damage_package)


func propagate_to_health() -> void:
	health.take_pure_damage(current_damage_package)


#TODO: I need to queue free the whole object
func death() -> void:
	if health.current_health <= 0.0:
		#print("Object died! ):")
		queue_free()
#endregion




# ========== Explanation and notes ========== #

#Expression 		| What it gives you
#child.get_script() | The script file (Shield.gd) resource attached to the node.
#child 				| The actual object instance, including properties and state.
