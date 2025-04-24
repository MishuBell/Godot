extends CharacterBody3D  # or Area3D

@export var speed = 2000.0          # Units per second
@export var direction = Vector3.FORWARD  # Local forward direction
@export var raycast_checks_every = 1     # Performance tweak

var last_position = Vector3.ZERO
var damage = 10

func _ready():
    last_position = global_position  # Initialize
    # Rotate projectile to face direction (if needed)
    look_at(global_position + direction, Vector3.UP)

func _physics_process(delta):
    # Update position and check collisions
    var new_position = global_position + (direction * speed * delta)
    check_collision_between(last_position, new_position)
    last_position = global_position  # Save for next frame
    move_projectile(delta)

func move_projectile(delta):
    var movement = direction * speed * delta
    velocity = movement  # For CharacterBody3D
    move_and_slide()     # Handles collisions (optional)
    # If using Area3D: position += movement * delta

func check_collision_between(from: Vector3, to: Vector3):
    var space_state = get_world_3d().direct_space_state
    var ray_query = PhysicsRayQueryParameters3D.create(
        to,    # Start at new position (B)
        from   # End at last position (A)
    )
    ray_query.collide_with_areas = true   # For Area3D
    ray_query.collide_with_bodies = true
    ray_query.collision_mask = 0b1        # Adjust layers
    
    var result = space_state.intersect_ray(ray_query)
    
    if result.is_empty():
        return
    
    var collider = result.collider
    if collider.is_in_group("damageable"):
        collider.take_damage(damage)
        queue_free()  # Destroy projectile