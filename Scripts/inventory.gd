# ========== inventory.gd ========== #
extends Area3D

@export var inventory_slots : Array[Node3D]

func _ready() -> void:
	inventory_slots[0].process_mode = Node.PROCESS_MODE_DISABLED
	inventory_slots[0].visible = false
	#inventory_slots[1].process_mode = Node.PROCESS_MODE_DISABLED
	#inventory_slots[1].visible = false

	area_entered.connect(_on_collision)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		#inventory_slots[1].process_mode = Node.PROCESS_MODE_DISABLED
		#inventory_slots[1].visible = false
		inventory_slots[0].process_mode = Node.PROCESS_MODE_ALWAYS
		inventory_slots[0].visible = true
	if Input.is_action_just_pressed("2"):
		inventory_slots[0].process_mode = Node.PROCESS_MODE_DISABLED
		inventory_slots[0].visible = false
		#inventory_slots[1].process_mode = Node.PROCESS_MODE_ALWAYS
		#inventory_slots[1].visible = true

func _on_collision(area: Area3D):
	if area.is_in_group("collectable"):
		print("YES HELLO")
		area.release_me()
	pass
