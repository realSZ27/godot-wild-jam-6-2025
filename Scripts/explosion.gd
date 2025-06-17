extends Node2D

func _ready():
	print("futa")	 
	for body in $Range.get_overlapping_bodies():
		if body.is_in_group("opp"):
			Global.explosion.emit(body)
