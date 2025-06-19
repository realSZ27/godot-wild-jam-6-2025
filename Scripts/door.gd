extends Node2D

@onready var animation_player := $AnimationPlayer

func open():
	animation_player.play("open door")

func close():
	animation_player.play_backwards("open door")

func _on_detection_area_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		open()

func _on_detection_area_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		close()
