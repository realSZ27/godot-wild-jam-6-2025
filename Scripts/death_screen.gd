extends Control


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Wall.tscn")
	pass # Replace with function body.


func _on_mainmenu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.
