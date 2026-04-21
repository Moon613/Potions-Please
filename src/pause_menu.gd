extends CanvasLayer

signal SwitchScene(id: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		SwitchScene.connect(get_tree().current_scene._switch_scene);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_save_button_up() -> void:
	SaveManager.save_game(0)

func _on_quit_button_up() -> void:
	visible = false
	GameInfo.get_tree().paused = false
	GameInfo.paused = false
	SwitchScene.emit(4)
	GameInfo.reset_info()
	get_tree().reload_current_scene()
	
