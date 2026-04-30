extends CanvasLayer

const GameInfoScript = preload("res://game_info.gd")

func _process(delta: float) -> void:
	$DayCount.text = "Day: " + str(GameInfo.dayCounter)
