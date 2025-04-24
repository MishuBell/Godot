# ========= damage_package.gd ============ #
extends Node
## This class carries damage values to be held by damaging objects and passed to recieving objects.
##
## Holds values for defining damage.
class_name DamagePackage

## Base damage value before applying any modifications
@export var damage_value : float
var damage_remainder : float
