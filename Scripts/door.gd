extends Node2D

@onready var animation_player := $AnimationPlayer
@onready var area := $"Detection Area"
var unlocked := true
var opened := false

func open():
	if not opened:
		opened = true
		animation_player.play("open door")

func close():
	if opened:
		opened = false
		animation_player.play_backwards("open door")
	
func _physics_process(delta):
	var bodies: Array[Node2D] = area.get_overlapping_bodies()
	print(str(bodies))
	for body in bodies:
		if (body.is_in_group("opp") or 
		(body.is_in_group("Player") and unlocked)):
			open()
			return
	close()

func _on_detection_area_body_entered(body: Node2D):
	return
	if body is CharacterBody2D:
		open()

func _on_detection_area_body_exited(body: Node2D):
	return
	if body is CharacterBody2D:
		close()
