extends Node2D

signal clickReleased;
signal ReturnToOverworld;
signal ChangeIngredients(ingr: String, amt: int);

var activeIngredients: Array[String] = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene") and get_tree().current_scene.has_method("_change_ingredient_amount"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);
		ChangeIngredients.connect(get_tree().current_scene._change_ingredient_amount);
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
