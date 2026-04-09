extends Node2D
signal ReturnToOverworld(id: int);
@onready var tutorial: Popup = $Tutorial

func _ready() -> void:
	if !GameInfo.acornsTutorial:
		tutorial.hide()
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene)

func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ReturnToOverworld.emit(0);
		self.queue_free()


func _on_tree_minigame_end() -> void:
	ReturnToOverworld.emit(0);
	self.queue_free()
	pass # Replace with function body.


func _on_tutorial_popup_hide() -> void:
	GameInfo.acornsTutorial = false
	pass # Replace with function body.
