# ========== shell_audio.gd ========== #
#region TODO's for 3D audio
##TODO(3D Audio/Non positional): in start - the audiostream is added to this node. When using a 3D audiostream, the parent must be changed to a node that is outside of this scene for spatial audio to happen. Or if no spatial audio is needed, change this to a AudioStreamPlayer.
#endregion
extends Node


@export var ammunition_data : res_AmmunitionData
@export_range(-60, 24, 0.1, "hide_slider") var db_level : float = 0.0 ## +6dB is double the volume. -6dB is half the volume.
@export_range(0, 12, 0.1) var max_hearable_distance ## Keep this low if there any any cpu overhead concerns


func start() -> void:
	if !ammunition_data || ammunition_data.sfx_shell_casings.is_empty():
		push_error("ShellAudio: No ammunition data or sounds!")
		return

# Create the audio stream player and prepare
	var throwaway_audiostream = AudioStreamPlayer3D.new()
	throwaway_audiostream.global_transform = get_parent().global_transform
	get_tree().current_scene.add_child(throwaway_audiostream)
	throwaway_audiostream.stream = ammunition_data.sfx_shell_casings.pick_random()
	throwaway_audiostream.volume_db = db_level
	throwaway_audiostream.max_distance = max_hearable_distance
	throwaway_audiostream.pitch_scale = randf_range(0.95, 1.05)
# Cleanup
	throwaway_audiostream.finished.connect(func(): throwaway_audiostream.queue_free())

	throwaway_audiostream.play()
