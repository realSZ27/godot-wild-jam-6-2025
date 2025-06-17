extends EnemyState
class_name EnemyPatrol

@onready var ray := $"../../RayCast2D"
@onready var nav_agent := $"../../NavigationAgent2D" as NavigationAgent2D
var eye_sight_distance := 400.0
var fov = PI / 2
var is_cooldown := false
var location
var start_location
var pause_at_location := false
var en_route := false

func enter():
	location = enemy.global_position
	start_location = location
	Global.explosion.connect(_explosion)

func physics_update(_delta: float):
	ray.target_position = ray.to_local(player.global_position)
	
	light_calc()
	distance_calc($"../../DetectionMeter".frame, cooldown_calc())
	
	# movement
	if $"../../DetectionMeter".frame == 21:
		location = player.global_position

	var next_pos = nav_agent.get_next_path_position()
	var dir = (next_pos - enemy.global_position).normalized()
	enemy.velocity = dir * speed
	#enemy.move_and_slide()

# calculates anger, detection, and death
func distance_calc(current_frame: int, timer_time: float):
	var vector_distance = player.global_position - enemy.global_position
	var distance_length = vector_distance.length()

	if distance_length > 400:
		if not is_cooldown and current_frame > 0:
			$"../../DetectionMeter".frame = current_frame - 1
			start_cooldown(timer_time)
	elif distance_length < 400 and distance_length > 55:
		if ray.is_colliding() and ray.get_collider() == player:
			if not is_cooldown and current_frame < 21:
				$"../../DetectionMeter".frame = current_frame + 1
			if not is_cooldown:
				Global.increase_anger()
				start_cooldown(timer_time)
		else:
			if not is_cooldown and current_frame > 0:
				$"../../DetectionMeter".frame = current_frame - 1
				start_cooldown(timer_time)
	elif distance_length < 60:
		get_tree().change_scene_to_file("res://Scenes/ui/death_screen.tscn")

# calculates the length of the detection meter cooldown
func cooldown_calc() -> float:
	# update cooldown based on anger
	var timer_time: float = 0.16
	var anger = Global.anger_amount
	if anger >= 0 and anger <= 6:
		timer_time = 0.16
	elif anger >= 7 and anger <= 22:
		timer_time = 0.08
	elif anger >= 23 and anger <= 27:
		timer_time = 0.04
	return timer_time

# turns on/off the lights
func light_calc():
	# turns off lights so you cant see them through walls
	if ray.is_colliding() and !ray.get_collider().is_in_group("environment"):
		$"../../Lights".visible = true
	else:
		$"../../Lights".visible = false

func start_cooldown(timer_time: float):
	is_cooldown = true
	$"../../Timers/CooldownTimer".start(timer_time)

func _on_cooldown_timer_timeout():
	is_cooldown = false

func _on_calc_path_timer_timeout():
	nav_agent.target_position = location

func _explosion(explosion, body):
	if self == body:
		location = explosion.global_position
		pause_at_location = true
		$"../../Timers/PauseAtLocationTimer".start()

func _on_navigation_agent_2d_target_reached():
	en_route = false
	if not pause_at_location:
		location = start_location

func _on_pause_at_location_timer_timeout():
	pause_at_location = false

func _on_navigation_agent_2d_path_changed():
	en_route = true
