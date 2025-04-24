extends Node #TODO: Maybe make this a ressource? We will see later. For now, Node is okay.
class_name Stats
## Player stats.
##
## Provides stats and functionality to manipulate incoming damage.

## This is the players health
@export var health : float = 300
@export var speed : float
@export var armor : float
@export var health_regen : float

func _ready() -> void:
	pass

## Configures damage adjustments [br]
## amount: [b] float - Base damage amount [/b] [br]
## percentage: float - Modifier applied to damage [br]
## [param damp_or_amp]: bool - TRUE = Damp damage, FALSE = Amplify damage [br]
func configure_damage(amount: float, percentage: float, damp_or_amp: bool) -> void:
	var value = amount * percentage
	if damp_or_amp:
		health -= value
	else:
		health += value
