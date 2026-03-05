extends Node2D

signal clickReleased;
signal ReturnToOverworld;

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ReturnToOverworld.emit(2);
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if !event.pressed:
				clickReleased.emit();
	else:
		pass
