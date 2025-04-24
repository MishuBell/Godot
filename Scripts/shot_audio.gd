# ========== shot_audio.gd ========== #
extends AudioStreamPlayer

func start() -> void:
	pitch_scale = randf_range(1.0, 1.2)
	play()
