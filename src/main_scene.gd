class_name MainScene
extends Node2D
@export var overworld: PackedScene = preload("res://Overworld/overworld.tscn")
@export var potionBrewing: PackedScene = preload("res://Potion Brewing/potion_brewing.tscn")
@export var insideHouse: PackedScene = preload("res://Overworld/inside_house.tscn")
@export var dewdrops: PackedScene = preload("res://Dewdrop Minigame/minigame.tscn")
@export var mainMenu: PackedScene = preload("res://Main Menu/Main Menu.tscn")
@export var acorns: PackedScene = preload("res://Acorn Mini Game/minigame.tscn")
@export var treesap: PackedScene = preload("res://Treesap Minigame/minigame.tscn")
@export var dragonEggs: PackedScene = preload("res://Dragon Egg Minigame/minigame.tscn")
@export var mandrakes: PackedScene = preload("res://Mandrake Minigame/MandrakeMinigame.tscn")
@export var upstairs: PackedScene = preload("res://Overworld/Upstairs.tscn")

@export var startingScene: int;

signal SceneChange(id: int)

@export var busy_scenes = [
	GameInfo.SceneID.POTIONBREWING,
	GameInfo.SceneID.DEWDROPS,
	GameInfo.SceneID.MAINMENU,
	GameInfo.SceneID.ACORNS,
	GameInfo.SceneID.TREESAP,
	GameInfo.SceneID.DRAGONEGGS,
	GameInfo.SceneID.MANDRAKES
];
var overworldScene;
var potionScene;
var insideScene;
var dewdropScene;
var mainMenuScene;
var acornScene;
var sapScene;
var eggScene;
var mandrakeScene;
var upstairsScene;
var currentScene: int = GameInfo.SceneID.MAINMENU;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneChange.connect(BgMusic._on_scene_change);
	var overworldInstance = overworld.instantiate();
	overworldInstance.name = "Overworld";
	
	var brewingInstance = potionBrewing.instantiate();
	brewingInstance.name = "Potion Brewing";
	
	var insideInstance = insideHouse.instantiate();
	insideInstance.name = "Inside House";
	
	var mainMenuInstance = mainMenu.instantiate();
	mainMenuInstance.name = "Main Menu";
	
	var upstairsInstance = upstairs.instantiate();
	upstairsInstance.name = "Upstairs";
	
	overworldScene = overworldInstance;
	potionScene = brewingInstance;
	insideScene = insideInstance;
	mainMenuScene = mainMenuInstance;
	upstairsScene = upstairsInstance;
	
	if startingScene != -1:
		_switch_scene(startingScene);
	else:
		_switch_scene(GameInfo.SceneID.MAINMENU)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass

func _switch_scene(id: int):
	if id in GameInfo.minigameEnergy and GameInfo.minigameEnergy[id] > GameInfo.energy:
		return;
	print("Switching to scene " + str(id))
	if self.get_children() and self.get_children()[0].has_method("Reset"):
		self.get_children()[0].Reset();
	if self.get_children():
		self.remove_child(self.get_children()[0]);
	
	if id in busy_scenes:
		GameInfo.inventoryButton.visible = false;
	else:
		GameInfo.inventoryButton.visible = true;
	
	match id:
		GameInfo.SceneID.OVERWORLD:
			SceneChange.emit(currentScene, id)
			self.add_child(overworldScene);
			currentScene = id
			if GameInfo.finishedGatheringTutorial and !GameInfo.minigameExit:
				DialogueManager.TutMinigameComplete();
				GameInfo.minigameExit = true;
			if !GameInfo.leftHouseForFirstTime:
				GameInfo.leftHouseForFirstTime = true;
		GameInfo.SceneID.POTIONBREWING:
			if !GameInfo.seenPotionBrewingScreen:
				DialogueManager.FirstTutorialPotionAttempt();
				GameInfo.seenPotionBrewingScreen = true;
			if GameInfo.openedInventory and !GameInfo.reenterPotionBrewingScreen:
				DialogueManager.SecondTutorialPotionAttempt();
				GameInfo.reenterPotionBrewingScreen = true;
			SceneChange.emit(currentScene, id)
			self.add_child(potionScene);
			currentScene = id
		GameInfo.SceneID.INSIDEHOUSE:
			if GameInfo.leftHouseForFirstTime:
				GameInfo.reenteredHouse = true;
			SceneChange.emit(currentScene, id)
			self.add_child(insideScene);
			currentScene = id
		GameInfo.SceneID.DEWDROPS:
			var dewdropInstance = dewdrops.instantiate();
			dewdropInstance.name = "Dewdrop Collecting";
			dewdropScene = dewdropInstance;
			SceneChange.emit(currentScene, id)
			self.add_child(dewdropScene);
			currentScene = id
		GameInfo.SceneID.MAINMENU:
			SceneChange.emit(currentScene, id)
			self.add_child(mainMenuScene);
			currentScene = id
		GameInfo.SceneID.ACORNS:
			var acornInstance = acorns.instantiate();
			acornInstance.name = "Acorn Minigame"
			acornScene = acornInstance;
			SceneChange.emit(currentScene, id)
			self.add_child(acornScene);
			currentScene = id
		GameInfo.SceneID.TREESAP:
			var sapInstance = treesap.instantiate();
			sapInstance.name = "Treesap Minigame"
			sapScene = sapInstance;
			SceneChange.emit(currentScene, id)
			self.add_child(sapScene);
			currentScene = id
		GameInfo.SceneID.DRAGONEGGS:
			var eggInstance = dragonEggs.instantiate();
			eggInstance.name = "Dragon Eggs Minigame"
			eggScene = eggInstance;
			SceneChange.emit(currentScene, id)
			self.add_child(eggScene);
			currentScene = id
		GameInfo.SceneID.MANDRAKES:
			var mandrakeInstance = mandrakes.instantiate()
			mandrakeInstance.name = "Mandrakes Minigame"
			mandrakeScene = mandrakeInstance
			SceneChange.emit(currentScene, id)
			self.add_child(mandrakeScene);
			currentScene = id
		GameInfo.SceneID.UPSTAIRS:
			SceneChange.emit(currentScene, id)
			self.add_child(upstairsScene);
			currentScene = id
		_:
			print("Unknown SceneID!")
		
		
	inv_panel_control(id)

func inv_panel_control(id: int):
	if id in busy_scenes:
		GameInfo.inventory.visible = false
		GameInfo.busy = true
	else:
		GameInfo.busy = false
 
