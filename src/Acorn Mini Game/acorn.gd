extends Node2D
signal ReturnToOverworld(id: int);

func _ready() -> void:
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene)

func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ReturnToOverworld.emit(0);
