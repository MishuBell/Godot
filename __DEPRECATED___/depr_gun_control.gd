# ========= gun_control.gd ============ #
extends Node3D
class_name Weapon

#region Variables
@onready var shell_particles: GPUParticles3D = %"shell particles"
@onready var muzzle: GPUParticles3D = %Muzzle
@onready var audio_stream_player_gun: AudioStreamPlayer = %"AudioStreamPlayer Gun"
@onready var animation_player: AnimationPlayer = %AnimationPlayer

##TODO: Factor away into ressources
@export var res_weapon_data : res_WeaponData
var weapon: res_WeaponData
var ammunition_types: Array[res_AmmunitionData] = []


var barrel_end : Marker3D = null
var can_fire : bool = true
#endregion

#region Built-in functions
func _ready() -> void:
	find_barrelend()
	_initialize(res_weapon_data)

	#if weapon.type == String():
		#print("NO TYPE DECLARED IN GUN")
#endregion

#region User functions
#func operate_gun() -> void:
	#if can_fire:
		#can_fire = false
		#shoot_bullet()
		#play_animation()
		#play_shot_sfx()
		#play_shell_sfx()
		#play_particle()
		#await get_tree().create_timer(gun_data.firerate).timeout
		#can_fire = true

func shoot_bullet() -> void:
	var bullet = ammunition_types[0].SCE_9_MM_NATO.instantiate()

	### Important: This gets the whole scene tree - NOT the character tree.
	#get_tree().current_scene.add_child(bullet)
#
	#bullet.damage_package.damage_value = gun_data.bullet_damage
	#print(bullet.damage_package.damage_value)
#
	#bullet.global_transform = barrel_end.global_transform
#

func play_animation() -> void:
	animation_player.play("kickback")


func play_shot_sfx() -> void:
	audio_stream_player_gun.pitch_scale = randf_range(1.0, 1.3)
	audio_stream_player_gun.play()


func play_shell_sfx() -> void:
	var current_audio_stream_player = AudioStreamPlayer.new()
	add_child(current_audio_stream_player)
	current_audio_stream_player.stream = ammunition_types[0].sfx_shell_casings.pick_random() ##TODO: Correct?!
	current_audio_stream_player.volume_db = -10
	current_audio_stream_player.play()
	current_audio_stream_player.finished.connect(func(): current_audio_stream_player.queue_free())

func play_particle() -> void:
	shell_particles.restart()
	shell_particles.emitting = true

	muzzle.restart()
	muzzle.emitting = true

func find_barrelend() -> void: #In ready
	var parent = get_parent()
	for child in parent.get_children():
		if child is Marker3D:
			barrel_end = child as Marker3D
			print("Found barrelend!")
			break
#endregion

#region Preparation
## TODO: Call _initialize to pass the resource to a usable variable. Is this correct?
func _initialize(weapon_data_ref: res_WeaponData):
	weapon = weapon_data_ref
##TODO: Is this correctly taking the array from the weapon and putting it into its own array?
	for type in ammunition_types:
		ammunition_types = weapon.ammunition_type
#endregion

# ========== Notes ==========
#TODO: Shoot_bullet should basically call shoot on the gun - only as a driver. This script handles too many concerns and is in dire need of a refactor.
