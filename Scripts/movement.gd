extends CharacterBody2D

@onready var camera := $Camera2D
@onready var timers = $TimerContainer.get_children()
@onready var los = $RayCast2D
@onready var hotbar = get_tree().get_first_node_in_group("Hotbar")
@onready var tilemap = get_tree().get_first_node_in_group("environment")
@onready var light = preload("res://Scenes/glow.tscn")

var speed := 400
var active_ability = 0
var cooldowns : Array[bool] = [0, 0, 0, 0, 0, 0, 0, 0]
# had to use this because i couldnt get custom data for the tile layers
# or add another physics layer
var walls : Array[Vector2i] = [Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3), Vector2i(4, 3)]

func _ready() -> void:
	hotbar.active_ability.connect(ability_selector)

func ability_selector(ability_index: int) -> void:
	active_ability = ability_index


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left click"):
		if cooldowns[active_ability - 1]:
			return
			
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
				return
			6:
				return
			7:
				# eventually i want to make it so the shadow has to move to the cursor instead 
				# of immediately teleporting but im just using this for now since it has the same 
				# effect it just is quicker to use
				los.target_position = los.to_local(get_global_mouse_position())
				los.force_raycast_update()
				print_debug(los.is_colliding())
				if !los.is_colliding():
					position = get_global_mouse_position()
			8:
				return
		start_timer()
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	# we should change look_at() later but it works for now
	#look_at(get_global_mouse_position())
	move_and_slide()

func remove_cooldown(ability: int):
	cooldowns[ability - 1] = 0

func start_timer():
	timers[active_ability - 1].start()
	cooldowns[active_ability - 1] = true
