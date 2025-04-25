extends Area3D

# DEBUG
# TODO: Draw a line between the two points for debugging
# TODO: Determine the maximum speed a projectile is allowed to have 
# before collision detection via raycast is becoming inconsistent 
# ToThink: Not sure if this needs to be an area3d anymore 
# Write a func that shoots the proj and increments the speed
# and a collision must happen as its bein shot at the collider
# save the value for the speed at the point where the collision breaks

@export var speed = 1000.0

@export var max_speed_allowed = # Determine this
var direction = Vector3.FORWARD
var last_position = Vector3.ZERO
@export var raycast_checks_every = 1
var frame_counter = 0


@onready var damage_package: DamagePackage = $"Damage Package"

func _ready():
	last_position = global_position

func _process(delta: float) -> void:
	frame_counter += 1
# increment speed too
	move_projectile(delta)
	if frame_counter % raycast_checks_every != 0:
		return

	var new_position = global_position + (direction * speed * delta)
	check_collision_between(last_position, new_position)
	last_position = global_position
# for good control quit the application 
# after one frame
func move_projectile(delta):
	var movement = -transform.basis.z * speed * delta
	position += movement

func check_collision_between(from: Vector3, to: Vector3):
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()

	ray_query.from = to
	ray_query.to = from
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = true

	var result = space_state.intersect_ray(ray_query)

	if result:
		var collider = result.collider
		if collider.is_in_group("damagable"):
			collider.has_method("take_damage")
			collider.take_damage(damage_package)
			queue_free()
