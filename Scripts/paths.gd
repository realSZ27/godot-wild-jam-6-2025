extends Node

@export var speed: float = .1

var opp_table := {}

func _ready():
	Global.reparent_opp.connect(_reparent_opp)
	Global.unparent_opp.connect(_unparent_opp)
	
func _physics_process(delta):
	for child in self.get_children():
		for grandchild in child.get_children():
			if grandchild is PathFollow2D:
				grandchild.progress_ratio += delta * speed

func _reparent_opp(target_opp):
	for child in get_all_descendants(self):
		if child == target_opp:
			var opp := child as CharacterBody2D
			var parent_node = opp_table.get(opp).get("parent") as PathFollow2D
			parent_node.progress_ratio = opp_table.get(opp).get("progress_ratio")
			opp.reparent(parent_node)
			opp.global_position = opp_table.get(opp).get("last_position")
			opp.velocity = Vector2.ZERO

func _unparent_opp(target_opp: CharacterBody2D):
	for child in get_all_descendants(self):
		if child == target_opp:
			var parent = child.get_parent()
			opp_table[child] = { "parent": parent, "progress_ratio": parent.progress_ratio, "last_position": child.global_position }
			child.reparent(self)

func get_all_descendants(node):
	var all_nodes := []
	for child in node.get_children():
		all_nodes.append(child)
		all_nodes += get_all_descendants(child)
	return all_nodes
	
func navigate_to_last_position():
	pass
