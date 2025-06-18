extends Node2D


func _ready():
	$AnimatedSprite2D.play()
	#you gotta give it time for it to detect the enemies
	await get_tree().create_timer(0.1).timeout
	for body in $ExplosionRange.get_overlapping_bodies():
		if body.is_in_group("opp"):
			body.queue_free()

func _on_animated_sprite_2d_animation_finished():
	queue_free()
