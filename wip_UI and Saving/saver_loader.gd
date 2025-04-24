extends Node
class_name SaveLoad

@onready var character_controller: CharacterBody3D = %"Character Controller"
@export var save_path : String = "res://savegame.tres"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quicksafe_-"):
		save_game()
	if Input.is_action_just_pressed("quickload_+"):
		load_game()

func save_game() -> void:
	var saved_game : SavedGame = SavedGame.new()
	saved_game.player_position = character_controller.global_position
	ResourceSaver.save(saved_game, save_path)
	print("Game saved!!")

func load_game() -> void:
	var saved_game : SavedGame = load(save_path)
	character_controller.global_position = saved_game.player_position 
	print("loaded game")
	pass
