# ========== gun_control.gd =========== #
extends Node3D
class_name WeaponControl


#region Variables
@export_group("Variables")
@export var shell_particles : GPUParticles3D
@export var shell_audio: Node
@export var shot_audio : AudioStreamPlayer
@export var model_animation : AnimationPlayer
@export var muzzle_particles : GPUParticles3D
@export var projectile_spawn_point : Marker3D
@export_subgroup("Properties")
@export var weapon_data : res_WeaponData
@export_group("")

var can_fire : bool = true

var shots_fired : int = 0
#endregion


#region Built-in functions
func _ready() -> void:
	get_projectile_spawn_point()


func _process(delta: float) -> void:
	match weapon_data.firemode:
		weapon_data.FireMode.SINGLE:
			if Input.is_action_just_pressed("left_click"):
				operate_gun()
		weapon_data.FireMode.AUTO:
			if Input.is_action_pressed("left_click") and can_fire:
				can_fire = false
				operate_gun()
				get_tree().create_timer(weapon_data.firerate).timeout.connect(can_fire_)
#endregion


#region User functions
func can_fire_() -> void:
	can_fire = true

func operate_gun() -> void:
	instantiate_projectile()
	shots_fired += 1
	print("Shot fired: ", shots_fired)
	shell_particles.start()
	shell_audio.start()
	shot_audio.start()
	model_animation.start()
	muzzle_particles.start()
	pass

func instantiate_projectile() -> void:
	var projectile = weapon_data.ammunition_type[0].SCE_9_MM_NATO.instantiate()
	projectile.global_transform = projectile_spawn_point.global_transform
	get_tree().current_scene.add_child(projectile)

func get_projectile_spawn_point() -> void:
	if projectile_spawn_point == null:
		push_error(self.name, " is missing projectile spawn point. Set in the inspector!")
		assert(projectile_spawn_point != null, self.name + " is missing projectile spawn point. Set in the inspector!")
#endregion
