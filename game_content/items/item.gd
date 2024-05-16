class_name Item extends Node2D

@export_range(0.0, 10.0) var cooldown: float = .2
@export_range(0.0, 2.0) var velocity_multiplier: float = .9

var is_on_cooldown: bool = false
var is_held_by_player: bool
var cooldown_timer: Timer

func _ready():
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.autostart = false
	cooldown_timer.timeout.connect(stop_cooldown)

	add_child(cooldown_timer)

func player_held_process(_delta: float) -> void:
	pass

func start_cooldown():
	is_on_cooldown = true
	cooldown_timer.start()

func stop_cooldown():
	is_on_cooldown = false
