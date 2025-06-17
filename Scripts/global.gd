extends Node

# put the things you want everything to have access to in here
# access it with Global.yourthing
# its basically the same as a static class in java

signal explosion(explosion, body)

# anger stuff -----------------
var anger_amount = 0

func increase_anger():
	if Global.anger_amount < 27:
		Global.anger_amount += 1

func decrease_anger():
	if Global.anger_amount > 0:
		Global.anger_amount -= 1
