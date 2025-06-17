extends AnimatedSprite2D

@onready var footstep: AudioStreamPlayer2D = $"../footstep"

# I LOVE JANK CODE 😁
func _process(_delta):
	if Input.is_action_pressed("right"):
		flip_h = false
		play("Player Walk")
	elif Input.is_action_pressed("left"):
		flip_h = true
		play("Player Walk")
	elif Input.is_action_pressed("up"):
		flip_h = false
		play("Player Walk")
	elif Input.is_action_pressed("down"):
		flip_h = false
		play("Player Walk")
	else:
		play("Player Idle")
	if Input.is_action_pressed("Pause"):
		get_tree().change_scene_to_file("res://Scenes/pause_menu.tscn")
