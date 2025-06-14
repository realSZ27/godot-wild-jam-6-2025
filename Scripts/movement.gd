extends CharacterBody2D

@export var speed = 400
@onready var camera = $Camera2D

func _physics_process(delta: float) -> void:
	#look_at(get_global_mouse_position())
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	move_and_slide()

# I LOVE JANK CODE 😁
func _process(_delta):
	if Input.is_action_pressed("right"):
		$Sprite2D.flip_h = false
		$Sprite2D.play("Player Walk")
	elif Input.is_action_pressed("left"):
		$Sprite2D.flip_h = true
		$Sprite2D.play("Player Walk")
	elif Input.is_action_pressed("up"):
		$Sprite2D.flip_h = false
		$Sprite2D.play("Player Walk")
	elif Input.is_action_pressed("down"):
		$Sprite2D.flip_h = false
		$Sprite2D.play("Player Walk")
	else:
		$Sprite2D.play("Player Idle")
