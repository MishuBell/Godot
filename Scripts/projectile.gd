# ========= projectile.gd ============ #
extends Area3D

#region Variables
@export var speed : float = 3
@export var my_range : float = 200
var distance_traveled : float = 0

@export var damage_package : DamagePackage

@export var raycast : RayCast3D

#endregion

#region Built-in functions
func _ready() -> void:
	area_entered.connect(_on_collision)


func _process(delta: float) -> void:
	propell_myself(delta)
	im_dead_soon()
#endregion

#region User functions
func propell_myself(delta) -> void:
	position += -transform.basis.z * speed * delta
	distance_traveled += 1

func im_dead_soon() -> void:
	if distance_traveled == my_range:
		queue_free()
	#get_tree().create_timer(my_range / speed).timeout.connect(queue_free) Ignore for now!

func _on_collision(area: Area3D):
	if area.is_in_group("damagable") and area.has_method("take_damage"):
		area.take_damage(damage_package)
		queue_free()

# This is only for when the area itself does not have the def
#func _on_collision(area: Area3D):
	#for child in area.get_children():
		#if child.is_in_group("damagable"):
			#print("Damageable found")
			#if child.has_method("take_damage"):
				#print("method found")
				#print(child.get_parent().name)
				#child.take_damage(damage_package)
				#queue_free()
#endregion
