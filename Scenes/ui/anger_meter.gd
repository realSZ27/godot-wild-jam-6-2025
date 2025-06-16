extends Control

# this whole file pretty aids but it works

var can_decrease := true
var can_decrease_step := true

func _ready():
	Global.anger_amount = 0

func _process(_delta):
	if Global.anger_amount > $AngerMeterSprite.frame:
		$DecreaseTimer.start()
		can_decrease = false
	$AngerMeterSprite.frame = Global.anger_amount
	if can_decrease:
		if can_decrease_step:
			Global.decrease_anger()
			$StepTimer.start()
			can_decrease_step = false

func _on_timer_timeout():
	can_decrease = true

func _on_step_timer_timeout():
	can_decrease_step = true
