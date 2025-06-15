extends CharacterBody2D


@onready var player : Node2D
@onready var ray := $RayCast2D
var eye_sight_distance := 400.0
var fov = PI / 2
var speed := 100.0
var is_cooldown := false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta) -> void:
	ray.target_position = ray.to_local(player.global_position)
	var current_frame = $AnimatedSprite2D.frame;
	
	#turns off lights so you cant see them through walls
	if ray.get_collider() == player:
		$Lights.visible = true
	else:
		$Lights.visible = false
	
	var vector_distance = player.global_position - global_position
	if  vector_distance.length() > 400:
		if !is_cooldown and current_frame > 0:
			$AnimatedSprite2D.frame = current_frame - 1
			print("changed frame down")
			start_cooldown()
		return
	elif vector_distance.length() < 55:
		get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")
	# this is bullshit and made up i spent like 1000 hours trying to figure this out 
	# everything else was easy its just this i hate angles so much 
	# trigonometry can go fuck itself soh cah toa
	#if (Vector2.RIGHT.rotated(rotation)).angle_to(vector_distance) > (fov / 2):
	#	return
	
	# makes it so they cant see you through walls n shit
	if !ray.is_colliding() or ray.get_collider() != player:
		return
	
	if !is_cooldown and current_frame < 21:
		$AnimatedSprite2D.frame = current_frame + 1
		print("changed frame up")
		start_cooldown()
	
	if current_frame == 21:
		chase(vector_distance)
		
func start_cooldown():
	is_cooldown = true
	$Timer.start()

func chase(vector_distance) -> void:
	# this works fine it just looks a bit jittery when youre super upclose
	# obv that wouldnt happen during the game but just wanted to mention
	# its kinda annoying
	if vector_distance.length() < 50:
		velocity = Vector2.ZERO
		return
	
	velocity = vector_distance / vector_distance.length() * speed
	move_and_slide()
	# should change how they look at you in the future since this makes
	# it look kinda janky, but it works for now
	#look_at(player.global_position)

func _on_timer_timeout():
	is_cooldown = false
	print("timer done")
