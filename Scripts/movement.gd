extends CharacterBody2D

@export var speed = 400
@onready var camera = $Camera2D

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	move_and_slide()
	
