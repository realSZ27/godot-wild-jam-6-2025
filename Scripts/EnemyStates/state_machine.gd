extends Node

@export var initial_state: State
@export var enemy: CharacterBody2D
@export var speed: float
@onready var player := get_tree().get_first_node_in_group("Player")

var current_state: State
var states := {}

# state machines are pretty cool
# i havent done it yet, but this will let us change it from following a path (hence patrol)
# to chasing the player, or checking out a bomb.
# the hierarchy is this:
# State -> EnemyState -> Each Individual State
# then this file sets each one up
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_child_transitioned)
			
			child.enemy = enemy
			child.speed = speed
			child.player = player
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float):
	#print(str(current_state))
	if current_state:
		current_state.update(delta)
	else:
		push_error("no current state found")
	
func _physics_process(delta: float):
	light_calc()
	if current_state:
		current_state.physics_update(delta)
	else:
		push_error("no current state found")

func _on_child_transitioned(state: State, new_state_name: String):
	if state != current_state:
		push_error("state passed does not match new state")
		return
	
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state:
		push_error("couldnt get new state")
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
	
	current_state = new_state

# turns off lights so you cant see them through walls
func light_calc():
	var ray = $"../RayCast2D"
	var lights = $"../Lights"
	ray.target_position = ray.to_local(player.global_position)
	if lights.ready:
		if ray.is_colliding() and ray.get_collider().is_in_group("Player"):
			lights.visible = true
		else:
			lights.visible = false
