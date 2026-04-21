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
	ChangeIngredients.connect(GameInfo._change_ingredient_amount);
	ReloadIngredientCount();
	for resource in GameInfo.resources:
		spawnedIngredients[resource] = 0;
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);
	
	if GameInfo.resources[GameInfo.DEWDROPS] == 0:
		$DewdropText.visible = false;
	else:
		$DewdropText.visible = true;
	if GameInfo.resources[GameInfo.ACORNS] == 0:
		$AcornText.visible = false;
	else:
		$AcornText.visible = true;
	if GameInfo.resources[GameInfo.EGGS] == 0:
		$DragonEggText.visible = false;
	else:
		$DragonEggText.visible = true;
	if GameInfo.resources[GameInfo.MANDRAKE] == 0:
		$MandrakeText.visible = false;
	else:
		$MandrakeText.visible = true;
	if GameInfo.resources[GameInfo.SAP] == 0:
		$SapText.visible = false;
	else:
		$SapText.visible = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"UI/Reputation Bar".value = GameInfo.reputation;
	$"UI/Stamina Bar".value = GameInfo.energy;
	if stirCyclesCompleted == 1 and mostRecentCheckpoint == 1:
		for recipe: GameInfo.Recipe in GameInfo.validRecipies:
			# Checks if every ingredient in the cauldron is in the recipe.
			# This check is preformed for each valid recipe until a candidate is found.
			if recipe.ingredients.all(func(ingredient): return ingredient in activeIngredients) and recipe.ingredients.size() == activeIngredients.size():
				SpawnPotion(recipe.output, recipe.image);
				Reset();
				return;
		SpawnPotion(GameInfo.RUINED, GameInfo.ruinedPotionSprite);
		Reset();

func SpawnPotion(type: String, image: Texture2D):
	GameInfo.energy -= GameInfo.minigameEnergy[1];
	GameInfo.potions[type] += 1;
	var potion = Sprite2D.new();
	potion.texture = image;
	potion.position = Vector2(416, 296);
	potion.name = "spawned potion";
	potion.set_script(load("res://Potion Brewing/spawned_potion.gd"))
	add_child(potion);

func ReloadIngredientCount():
	#$HoneyText.text = get_tree().current_scene.resources[]
	$DewdropText.text = str(GameInfo.resources[GameInfo.DEWDROPS]);
	$AcornText.text = str(GameInfo.resources[GameInfo.ACORNS]);
	$DragonEggText.text = str(GameInfo.resources[GameInfo.EGGS]);
	$MandrakeText.text = str(GameInfo.resources[GameInfo.MANDRAKE]);
	$SapText.text = str(GameInfo.resources[GameInfo.SAP]);

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
	$Spoon.Reset();
	activeIngredients.clear();
	for ingr in spawnedIngredients:
		spawnedIngredients[ingr] = 0;
	self.stirCyclesCompleted = 0;
	self.mostRecentCheckpoint = 0;
	clickReleased.emit();

func _on_stir_checkpoint_reached(num: int):
	if mostRecentCheckpoint == 4 and num == 1:
		mostRecentCheckpoint = 1;
		stirCyclesCompleted += 1;
	elif mostRecentCheckpoint == num-1:
		mostRecentCheckpoint = num;

func _on_not_enough_energy():
	$AnimationPlayer.play("Stamina Shaking");
