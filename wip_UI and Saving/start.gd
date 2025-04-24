extends Button

const TEST_WORLD = preload("res://Scenes/test_world.tscn")

func _pressed() -> void:
	get_tree().change_scene_to_packed(TEST_WORLD)
