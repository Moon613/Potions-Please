extends Node2D
signal ReturnToOverworld(id: int);
signal ChangeIngredients(ingr: String, amt: int);
@onready var tutorial: Popup = $Tutorial
var acornsCollected: int = 0

func _ready() -> void:
	ChangeIngredients.connect(GameInfo._change_ingredient_amount);
	if !GameInfo.acornsTutorial:
		tutorial.hide()
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene)

func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ChangeIngredients.emit("acorns", acornsCollected)
		ReturnToOverworld.emit(0);
		self.queue_free()


func _on_tree_minigame_end() -> void:
	ChangeIngredients.emit("acorns", acornsCollected)
	ReturnToOverworld.emit(0);
	self.queue_free()
	pass


func _on_tutorial_popup_hide() -> void:
	GameInfo.acornsTutorial = false
	pass
