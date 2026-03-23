extends Node2D

signal clickReleased;
signal ReturnToOverworld(id: int);
signal ChangeIngredients(ingr: String, amt: int);

var activeIngredients: Array[String] = [];
var spawnedIngredients: Dictionary[String, int] = {};
var mostRecentCheckpoint: int = 0;
var stirCyclesCompleted: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene") and get_tree().current_scene.has_method("_change_ingredient_amount"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);
		ChangeIngredients.connect(get_tree().current_scene._change_ingredient_amount);
		ReloadIngredientCount();
		for resource in get_tree().current_scene.resources:
			spawnedIngredients[resource] = 0;
		$"UI/Reputation Bar".value = get_tree().current_scene.reputation;
		$"UI/Stamina Bar".value = get_tree().current_scene.energy;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stirCyclesCompleted == 2 and mostRecentCheckpoint == 1:
		Reset();
		ReturnToOverworld.emit(2);

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

func Reset():
	$Spoon.position = Vector2(-184, 50)
	$Spoon.rotation_degrees = 11.6;
	$Spoon.FOLLOW_MOUSE = false;
	activeIngredients.clear();
	for ingr in spawnedIngredients:
		spawnedIngredients[ingr] = 0;
	self.stirCyclesCompleted = 0;
	self.mostRecentCheckpoint = 0;

func _on_stir_checkpoint_reached(num: int):
	if mostRecentCheckpoint == 4 and num == 1:
		mostRecentCheckpoint = 1;
		stirCyclesCompleted += 1;
	elif mostRecentCheckpoint == num-1:
		mostRecentCheckpoint = num;
