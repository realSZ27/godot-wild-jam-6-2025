extends Control

@onready var buttons := $"PanelContainer/Icon Container".get_children()
signal active_ability(ability_index)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and !event.is_echo():
		var index = event.keycode - KEY_1 
		if index >= 0 and index < buttons.size():
			toggle_slot(index)

func toggle_slot(i: int) -> void:
	buttons[i].button_pressed = !buttons[i].button_pressed
	for index in range(buttons.size()):
		if index != i:
			buttons[index].button_pressed = false
	active_ability.emit(i + 1)
	
	var shineSprite = buttons[i].get_child(1)
	shineSprite.play("shine")
