extends CharacterBody2D

@onready var player : Node2D
@onready var ray := $RayCast2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
var eye_sight_distance := 400.0
var fov = PI / 2
var speed := 450.0
var is_cooldown := false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta: float) -> void:
	# update cooldown based on anger
	var timer_time: float = 0.16
	var anger = Global.anger_amount
	if anger >= 0 and anger <= 6:
		timer_time = 0.16
	elif anger >= 7 and anger <= 22:
		timer_time = 0.08
	elif anger >= 23 and anger <= 27:
		timer_time = 0.04
	
	ray.target_position = ray.to_local(player.global_position)
	var current_frame = $AnimatedSprite2D.frame;
	
	# turns off lights so you cant see them through walls
	if ray.is_colliding() and !ray.get_collider().is_in_group("environment"):
		$Lights.visible = true
	else:
		$Lights.visible = false
	
	var vector_distance = player.global_position - global_position
	var distance_length = vector_distance.length()

	if distance_length > 400:
		if not is_cooldown and current_frame > 0:
			$AnimatedSprite2D.frame = current_frame - 1
			start_cooldown(timer_time)
	elif distance_length < 400 and distance_length > 55:
		if ray.is_colliding() and ray.get_collider() == player:
			if not is_cooldown and current_frame < 21:
				$AnimatedSprite2D.frame = current_frame + 1
			if not is_cooldown:
				Global.increase_anger()
				start_cooldown(timer_time)
		else:
			if not is_cooldown and current_frame > 0:
				$AnimatedSprite2D.frame = current_frame - 1
				start_cooldown(timer_time)
	elif distance_length < 60:
		get_tree().change_scene_to_file("res://Scenes/ui/death_screen.tscn")
	
	if current_frame == 21:
		# pathfinding
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed
		move_and_slide()


func start_cooldown(timer_time: float):
	is_cooldown = true
	$CooldownTimer.start(timer_time)

func make_path() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	is_cooldown = false

func _on_calc_path_timer_timeout():
	make_path()
