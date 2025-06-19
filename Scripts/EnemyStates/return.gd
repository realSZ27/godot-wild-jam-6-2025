extends EnemyState
class_name EnemyReturn

@onready var nav_agent := $"../../NavigationAgent2D" as NavigationAgent2D
@onready var detection_meter = $"../../DetectionMeter"
@onready var ray = $"../../RayCast2D"
var is_cooldown: bool

func _ready():
	Global.explosion.connect(_explosion)

func enter():
	detection_meter.frame = 0

func physics_update(_delta):
	nav_agent.target_position = Global.last_position
	distance_calc(detection_meter.frame, cooldown_calc())
	if detection_meter.frame == 21:
		Transitioned.emit(self, "Chase")
	
	var next_pos = nav_agent.get_next_path_position()
	var dir = (next_pos - enemy.global_position).normalized()
	enemy.velocity = dir * speed

# calculates anger, detection, and death (based on distance)
func distance_calc(current_frame: int, timer_time: float):
	var vector_distance = player.global_position - enemy.global_position
	var distance_length = vector_distance.length()

	if distance_length > 400:
		if not is_cooldown and current_frame > 0:
			detection_meter.frame = current_frame - 1
			start_cooldown(timer_time)
	elif distance_length < 400 and distance_length > 55:
		if ray.is_colliding() and ray.get_collider() == player:
			if not is_cooldown and current_frame < 21:
				detection_meter.frame = current_frame + 1
			if not is_cooldown:
				Global.increase_anger()
				start_cooldown(timer_time)
		else:
			if not is_cooldown and current_frame > 0:
				detection_meter.frame = current_frame - 1
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
	
func start_cooldown(timer_time: float):
	is_cooldown = true
	$"../../Timers/CooldownTimer".start(timer_time)

func _on_cooldown_timer_timeout():
	is_cooldown = false
	
func _on_navigation_agent_2d_target_reached():
	Global.reparent_opp.emit(enemy)
	Transitioned.emit(self, "Patrol")
	
func _explosion(explosion, body):
	print("EXXPLOOOOOOSION")
