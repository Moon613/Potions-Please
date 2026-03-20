extends Node2D

signal clickReleased;
signal ReturnToOverworld;
signal ChangeIngredients(ingr: String, amt: int);

var activeIngredients: Array[String] = [];
var spawnedIngredients: Dictionary[String, int] = {};

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene") and get_tree().current_scene.has_method("_change_ingredient_amount"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);
		ChangeIngredients.connect(get_tree().current_scene._change_ingredient_amount);
		ReloadIngredientCount();
		for resource in get_tree().current_scene.resources:
			spawnedIngredients[resource] = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ReloadIngredientCount():
	#$HoneyText.text = get_tree().current_scene.resources[]
	$DewdropText.text = str(get_tree().current_scene.resources["dewdrops"]);
	$AcornText.text = str(get_tree().current_scene.resources["acorns"]);

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ReturnToOverworld.emit(2);
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if !event.pressed:
				clickReleased.emit();
	else:
		pass

func _on_ingredient_consumed(type: String):
	ChangeIngredients.emit(type, -1);
	spawnedIngredients[type] -= 1;
	activeIngredients.append(type);
	ReloadIngredientCount();
