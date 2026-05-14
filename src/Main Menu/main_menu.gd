extends Control

signal tempSignal(int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		tempSignal.connect(get_tree().current_scene._switch_scene)
	$AudioStreamPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if not FileAccess.file_exists("user://SaveFile0.save"):
		#$"Load Game".disabled = true
	#else:
		#$"Load Game".disabled = false
	pass

func _on_new_game_pressed() -> void:
	$AudioStreamPlayer.stop()
	tempSignal.emit(GameInfo.SceneID.UPSTAIRS);
	DialogueManager.IntroDialogue();

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_load_game_pressed() -> void:
	$AudioStreamPlayer.stop()
	SaveManager.load_game(0)
	tempSignal.emit(2)
