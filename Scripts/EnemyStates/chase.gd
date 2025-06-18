extends EnemyState
class_name EnemyChase

@onready var ray := $"../../RayCast2D"
@onready var detection_meter := $"../../DetectionMeter"
@onready var nav_agent := $"../../NavigationAgent2D" as NavigationAgent2D
var is_cooldown := false
var pause_at_location := false
var en_route := false
var start_location

func enter():
	Global.unparent_opp.emit($"../..")
	$"../../DetectionMeter".frame = 0
	$"../../Timers/CalcPathTimer".start()

func exit():
	# this is just temporary, it should walk to the new spot before doing this
	# also it should walk to wherever it ended last
	# maybe a new state would be the best for that
	Global.reparent_opp.emit($"../..")

func physics_update(_delta: float):
	#print("chase state")
	var vector_distance = player.global_position - enemy.global_position
	var distance_length = vector_distance.length()
	
	if distance_length > 400:
		Transitioned.emit(self, "Patrol")
	elif distance_length < 60:
		get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")

	var next_pos = nav_agent.get_next_path_position()
	var dir = (next_pos - enemy.global_position).normalized()
	enemy.velocity = dir * speed
	
func _on_calc_path_timer_timeout():
	nav_agent.target_position = player.global_position
