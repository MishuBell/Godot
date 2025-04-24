class_name Shield
extends Node

## Emitted when shield takes damage
signal shield_damaged(amount, remaining)
## Emitted when shield breaks
signal shield_broken
## Emitted when shield begins recharging
signal recharge_started
## Emitted when shield is fully recharged
signal recharge_complete
## Emitted when shield is disabled/enabled
signal shield_toggled(is_enabled)

@export var max_shield := 100.0
@export var recharge_rate := 25.0  # per second
@export var recharge_delay := 3.0  # seconds after last damage before recharge starts
@export var can_recharge_when_broken := false
@export var start_enabled := true

var current_shield: float:
    set(value):
        current_shield = clampf(value, 0, max_shield)
        if current_shield <= 0:
            _break_shield()
        elif current_shield >= max_shield:
            recharge_complete.emit()

var is_broken := false
var is_enabled := true
var recharge_timer: Timer
var recharge_cooldown_timer: Timer

# Buff system
var recharge_rate_multiplier := 1.0
var recharge_delay_multiplier := 1.0
var max_shield_multiplier := 1.0

# Damage tracking
var overflow_damage := 0.0
var has_overflowed := false

func _ready():
    current_shield = max_shield
    is_enabled = start_enabled
    
    # Setup recharge delay timer
    recharge_cooldown_timer = Timer.new()
    add_child(recharge_cooldown_timer)
    recharge_cooldown_timer.one_shot = true
    recharge_cooldown_timer.timeout.connect(_start_recharge)
    
    # Setup recharge timer
    recharge_timer = Timer.new()
    add_child(recharge_timer)
    recharge_timer.timeout.connect(_recharge_tick)

func take_damage(amount: float) -> float:
    if not is_enabled or is_broken:
        return amount
    
    # Handle overflow damage case
    if has_overflowed:
        _break_shield()
        return amount
    
    # Stop any active recharging
    _stop_recharge()
    
    var damage_to_shield = min(amount, current_shield)
    current_shield -= damage_to_shield
    shield_damaged.emit(damage_to_shield, current_shield)
    
    # Handle overflow damage tracking
    var remaining_damage = amount - damage_to_shield
    if remaining_damage > 0:
        overflow_damage = remaining_damage
        has_overflowed = true
        _break_shield()
        return remaining_damage
    
    # Start recharge delay timer
    recharge_cooldown_timer.start(recharge_delay * recharge_delay_multiplier)
    
    return 0.0

func _recharge_tick():
    if not is_enabled or (is_broken and not can_recharge_when_broken):
        _stop_recharge()
        return
    
    current_shield += recharge_rate * recharge_rate_multiplier * recharge_timer.wait_time
    
    if current_shield >= max_shield * max_shield_multiplier:
        current_shield = max_shield * max_shield_multiplier
        _stop_recharge()
        recharge_complete.emit()

func _start_recharge():
    if not is_enabled or (is_broken and not can_recharge_when_broken):
        return
    
    recharge_timer.start(0.1)  # small interval for smooth recharge
    recharge_started.emit()

func _stop_recharge():
    recharge_timer.stop()

func _break_shield():
    if is_broken:
        return
    
    is_broken = true
    _stop_recharge()
    shield_broken.emit()

func repair_shield():
    is_broken = false
    has_overflowed = false
    overflow_damage = 0.0
    current_shield = max_shield * max_shield_multiplier

func toggle_shield(enable: bool):
    if is_enabled == enable:
        return
    
    is_enabled = enable
    shield_toggled.emit(is_enabled)
    
    if is_enabled:
        recharge_cooldown_timer.start(recharge_delay * recharge_delay_multiplier)
    else:
        _stop_recharge()

# Buff system functions
func apply_buff(
    recharge_rate_buff: float = 0.0, 
    recharge_delay_buff: float = 0.0, 
    max_shield_buff: float = 0.0,
    duration: float = 0.0
):
    recharge_rate_multiplier += recharge_rate_buff
    recharge_delay_multiplier += recharge_delay_buff
    max_shield_multiplier += max_shield_buff
    
    if duration > 0:
        await get_tree().create_timer(duration).timeout
        remove_buff(recharge_rate_buff, recharge_delay_buff, max_shield_buff)

func remove_buff(
    recharge_rate_buff: float = 0.0, 
    recharge_delay_buff: float = 0.0, 
    max_shield_buff: float = 0.0
):
    recharge_rate_multiplier -= recharge_rate_buff
    recharge_delay_multiplier -= recharge_delay_buff
    max_shield_multiplier -= max_shield_buff
    
    # Ensure values don't go below minimum
    recharge_rate_multiplier = max(recharge_rate_multiplier, 0.1)
    recharge_delay_multiplier = max(recharge_delay_multiplier, 0.1)
    max_shield_multiplier = max(max_shield_multiplier, 0.1)
    
    # Adjust current shield if max shield changed
    current_shield = min(current_shield, max_shield * max_shield_multiplier)