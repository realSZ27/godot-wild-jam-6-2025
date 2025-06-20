extends CharacterBody2D

@onready var shadowslave: AudioStreamPlayer2D = $shadowslave
@onready var camera := $Camera2D
@onready var timers = $TimerContainer.get_children()
@onready var los = $RayCast2D
@onready var hotbar = get_tree().get_first_node_in_group("Hotbar")
@onready var tilemap = get_tree().get_first_node_in_group("environment")
@onready var light = preload("res://Scenes/glow.tscn")
@onready var explosion = preload("res://Scenes/explosion.tscn")

var speed := 400
var active_ability = 0
var cooldowns : Array[bool] = [0, 0, 0, 0, 0, 0, 0, 0]

func _ready() -> void:
	hotbar.active_ability.connect(ability_selector)

func ability_selector(ability_index: int) -> void:
	active_ability = ability_index

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left click"):
		if cooldowns[active_ability - 1]:
			return
		#print_debug("1")
		match active_ability:
			1:
				return
			2:
				for body in $GlowAbilityRange.get_overlapping_bodies():
					if !body.is_in_group("environment"):
						var new_light = light.instantiate()
						body.add_child(new_light)
			3:
				return
			4:
				Global.anger_amount = 4
			5:
				los.target_position = los.to_local(get_global_mouse_position())
				los.force_raycast_update()
				#print_debug(los.is_colliding())
				if !los.is_colliding():
					var new_explosion = explosion.instantiate()
					new_explosion.position = get_global_mouse_position()
					tilemap.add_child(new_explosion)
					#print("added explosion")
			6:
				return
			7:
				# eventually i want to make it so the shadow has to move to the cursor instead 
				# of immediately teleporting but im just using this for now since it has the same 
				# effect it just is quicker to use
				los.target_position = los.to_local(get_global_mouse_position())
				los.force_raycast_update()
				#print_debug(los.is_colliding())
				if !los.is_colliding():
					position = get_global_mouse_position()
				shadowslave.play()
			8:
				return
		start_cooldown()
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	# we should change look_at() later but it works for now
	#look_at(get_global_mouse_position())
	move_and_slide()

func remove_cooldown(ability: int):
	#print_debug(str(ability - 1) + " cooldown ended")
	cooldowns[ability - 1] = false

func start_cooldown():
	timers[active_ability - 1].start()
	cooldowns[active_ability - 1] = true
