extends EnemyState
class_name EnemyChase

@onready var nav_agent := $"../../NavigationAgent2D" as NavigationAgent2D

func enter():
	Global.unparent_opp.emit($"../..")
	$"../../DetectionMeter".frame = 0
	$"../../Timers/CalcPathTimer".start()

func physics_update(_delta: float):
	var vector_distance = player.global_position - enemy.global_position
	var distance_length = vector_distance.length()
	
	if distance_length > 400:
		print("going to return")
		Transitioned.emit(self, "Return")
	elif distance_length < 60:
		get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")

	var next_pos = nav_agent.get_next_path_position()
	var dir = (next_pos - enemy.global_position).normalized()
	enemy.velocity = dir * speed
	
func _on_calc_path_timer_timeout():
	nav_agent.target_position = player.global_position
