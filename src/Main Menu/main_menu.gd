extends Control
signal tempSignal(int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"): 
		tempSignal.connect(get_tree().current_scene._switch_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_game_pressed() -> void:
	tempSignal.emit(2)



func _on_quit_pressed() -> void:
	get_tree().quit()
