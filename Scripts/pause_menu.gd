extends Control


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
	pass # Replace with function body.


func _on_mainmenu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.
