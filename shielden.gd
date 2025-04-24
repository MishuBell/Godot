extends CharacterBody3D

@export var shield_node: Shield

func _ready():
    # Connect to shield signals
    shield_node.shield_damaged.connect(_on_shield_damaged)
    shield_node.shield_broken.connect(_on_shield_broken)
    shield_node.recharge_started.connect(_on_recharge_started)
    
    # Example: Apply a temporary buff
    shield_node.apply_buff(
        recharge_rate_buff=0.5,  # +50% recharge rate
        recharge_delay_buff=-0.3, # -30% recharge delay
        duration=10.0            # lasts 10 seconds
    )

func take_damage(amount: float):
    var remaining_damage = shield_node.take_damage(amount)
    
    if remaining_damage > 0:
        # Apply remaining damage to health
        health -= remaining_damage

func _on_shield_damaged(amount, remaining):
    print("Shield took ", amount, " damage (", remaining, " remaining)")

func _on_shield_broken():
    print("Shield broken!")

func _on_recharge_started():
    print("Shield started recharging")