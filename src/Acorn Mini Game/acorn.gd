extends Node2D
signal ReturnToOverworld(id: int);
signal ChangeIngredients(ingr: String, amt: int);
signal ShowIngredient;
@onready var tutorial: Popup = $Tutorial
var acornsCollected: int = 0

func _ready() -> void:
	ChangeIngredients.connect(GameInfo._change_ingredient_amount);
	if GameInfo.acornsTutorial:
		$Tutorial.popup();
		$Tutorial.move_to_center();
	else:
		$Tutorial.hide()
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene)

func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel") and GameInfo.busy:
		get_viewport().set_input_as_handled()
		ChangeIngredients.emit("acorns", acornsCollected)
		ReturnToOverworld.emit(0);
		GameInfo.finishedGatheringTutorial = true;
		self.queue_free()


func _on_tree_minigame_end() -> void:
	ShowIngredient.emit()
	
func _on_ingredient_done_showing():
	ChangeIngredients.emit("acorns", acornsCollected);
	ReturnToOverworld.emit(0);
	GameInfo.finishedGatheringTutorial = true;
	GameInfo.energy -= GameInfo.minigameEnergy[GameInfo.SceneID.TREESAP];
	self.queue_free()

func _on_tutorial_popup_hide() -> void:
	GameInfo.acornsTutorial = false
	get_tree().paused = false

func _on_info_button_pressed() -> void:
	GameInfo.dragoneggTutorial = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Tutorial.popup();
	$Tutorial.move_to_center();
