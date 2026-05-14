extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sleep_trigger_interacted_with() -> void:
	$AnimationPlayer.play("Fade To Black");
	GameInfo.dayCounter += 1;
	GameInfo.busy = true;
	# If the day count is a multiple of 5, then refresh all eligible ingredients up to a max of 5
	if GameInfo.dayCounter%5 == 0:
		for i in GameInfo.resources.size()-5:
			GameInfo.resources[GameInfo.resources.keys()[i+5]] = clamp(GameInfo.resources.values()[i+5], 0, 5);

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Fade To Black":
		GameInfo.busy = false;
		GameInfo.energy = 5;
		
		var questsToErase: Array[int] = [];
		for i: int in GameInfo.currentQuests.size():
			if GameInfo.dayCounter > GameInfo.currentQuests[i].DayDue():
				questsToErase.append(i);
		for num: int in questsToErase:
			GameInfo.currentQuests.remove_at(num);
