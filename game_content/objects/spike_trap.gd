extends Area2D

var should_despawn: bool

func despawn():
	if should_despawn:
		queue_free()
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("spike_rise")

func _on_Area2D_body_entered(body):
	if body is PlayerController:
		var target_node = body.get_node("Health")
		if target_node is Health:
			var health_target = target_node as Health
			health_target.take_damage(5, global_position)

