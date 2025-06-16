extends PointLight2D


func _ready() -> void:
	$Timer.start()
	
# this is supposed to animate the brightness
# but it doesnt work
# gotta figure out why but i dont feel like it
#func _physics_process(_delta):
#	var light_intensity = $".".energy
#	light_intensity = lerp(light_intensity, 0.0, 1.0)

func _on_timer_timeout() -> void:
	queue_free()
