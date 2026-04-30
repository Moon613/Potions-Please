extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sleep_trigger_interacted_with() -> void:
	$AnimationPlayer.play("Fade To Black")
	GameInfo.dayCounter += 1
	GameInfo.busy = true;


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Fade To Black":
		GameInfo.busy = false;
		GameInfo.energy = clamp(GameInfo.energy + 5, 0, 5);
