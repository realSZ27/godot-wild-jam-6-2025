extends Node2D

var has_emitted: bool = false

func _ready():
	$AnimatedSprite2D.play()

func _physics_process(_delta):
	if has_emitted:
		return
	for body in $ExplosionRange.get_overlapping_bodies():
		if body.is_in_group("opp"):
			has_emitted = true
			Global.explosion.emit(self, body)

func _on_animated_sprite_2d_animation_finished():
	queue_free()
