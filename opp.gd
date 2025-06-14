extends CharacterBody2D

var speed = 10
var player_chase = false
var player = null

func _physics_process(delta):

	if player_chase:
		if position.distance_to(player.position) > 10:
			position+=(player.position-position)/speed
	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true



func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
