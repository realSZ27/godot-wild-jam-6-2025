extends CharacterBody2D


@onready var player : Node2D
@onready var ray := $RayCast2D
var eye_sight_distance := 400.0
var fov = PI / 2
var speed := 200.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	
	var vector_distance = player.global_position - global_position
	if  vector_distance.length() > 400:
		return
	
	if vector_distance.length() < 150:
		chase(vector_distance, delta)
	
	
	# this is bullshit and made up i spent like 1000 hours trying to figure this out 
	# everything else was easy its just this i hate angles so much 
	# trigonometry can go fuck itself
	#if (Vector2.RIGHT.rotated(rotation)).angle_to(vector_distance) > (fov / 2):
	#	return
	
	
	# makes it so they cant see you through walls n shit
	ray.target_position = ray.to_local(player.global_position)
	
	if ray.get_collider() == player:
		$Lights.visible = true
	else:
		$Lights.visible = false
	
	if !ray.is_colliding() or ray.get_collider() != player:
		return
	
	chase(vector_distance, delta)
	
func chase(vector_distance, delta) -> void:
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
	look_at(player.global_position)
