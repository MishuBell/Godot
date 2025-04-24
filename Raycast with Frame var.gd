extends KinematicBody2D  # or Area2D

var speed = 2000.0       # High speed (pixels/sec)
var direction = Vector2.RIGHT  # Facing direction
var last_position = Vector2.ZERO
var raycast_checks_every = 1  # Check every frame (adjustable)
var frame_counter = 0
var damage = 10

func _ready():
    last_position = global_position  # Initialize last position

func _physics_process(delta):
    frame_counter += 1
    if frame_counter % raycast_checks_every != 0:
        move_projectile(delta)  # Skip raycast this frame
        return
    
    var new_position = global_position + (direction * speed * delta)
    check_collision_between(last_position, new_position)
    last_position = global_position  # Update for next frame
    move_projectile(delta)

func move_projectile(delta):
    var movement = direction * speed * delta
    move_and_collide(movement)  # Or move with Area2D

func check_collision_between(from: Vector2, to: Vector2):
    var space_state = get_world_2d().direct_space_state
    var ray_query = Physics2DRayShapeQueryParameters.new()
    ray_query.from = to      # Ray from new position (B)
    ray_query.to = from      # Ray to last position (A)
    ray_query.collide_with_areas = true  # If using Area2D
    ray_query.collide_with_bodies = true
    ray_query.collision_mask = 0b1  # Adjust collision layer
    
    var result = space_state.intersect_ray(ray_query)
    
    if result:
        var collider = result.collider
        if collider.is_in_group("damageable"):
            collider.take_damage(damage)
            queue_free()  # Destroy projectile