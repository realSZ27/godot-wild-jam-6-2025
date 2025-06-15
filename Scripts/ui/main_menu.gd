extends Control




func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/Wall.tscn")


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/ui/options.tscn")
	pass # Replace with function body.
