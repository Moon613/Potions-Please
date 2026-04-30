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

@export var startingScene: int;

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var overworldInstance = overworld.instantiate();
	overworldInstance.name = "Overworld";
	
	var brewingInstance = potionBrewing.instantiate();
	brewingInstance.name = "Potion Brewing";
	
	var insideInstance = insideHouse.instantiate();
	insideInstance.name = "Inside House";
	
	var mainMenuInstance = mainMenu.instantiate();
	mainMenuInstance.name = "Main Menu";
	
	overworldScene = overworldInstance;
	potionScene = brewingInstance;
	insideScene = insideInstance;
	mainMenuScene = mainMenuInstance;
	
	if startingScene != -1:
		_switch_scene(startingScene);
	else:
		_switch_scene(4)
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
			self.add_child(overworldScene);
			if !GameInfo.leftHouseForFirstTime:
				GameInfo.leftHouseForFirstTime = true;
		GameInfo.SceneID.POTIONBREWING:
			if !GameInfo.seenPotionBrewingScreen:
				DialogueManager.FirstTutorialPotionAttempt();
			self.add_child(potionScene);
		GameInfo.SceneID.INSIDEHOUSE:
			if GameInfo.potionBookGet and !GameInfo.seenPotionBrewingScreen:
				GameInfo.seenPotionBrewingScreen = true;
			if GameInfo.leftHouseForFirstTime:
				GameInfo.reenteredHouse = true;
			self.add_child(insideScene);
		GameInfo.SceneID.DEWDROPS:
			var dewdropInstance = dewdrops.instantiate();
			dewdropInstance.name = "Dewdrop Collecting";
			dewdropScene = dewdropInstance;
			self.add_child(dewdropScene);
		GameInfo.SceneID.MAINMENU:
			self.add_child(mainMenuScene);
		GameInfo.SceneID.ACORNS:
			var acornInstance = acorns.instantiate();
			acornInstance.name = "Acorn Minigame"
			acornScene = acornInstance;
			self.add_child(acornScene);
		GameInfo.SceneID.TREESAP:
			var sapInstance = treesap.instantiate();
			sapInstance.name = "Treesap Minigame"
			sapScene = sapInstance;
			self.add_child(sapScene);
		GameInfo.SceneID.DRAGONEGGS:
			var eggInstance = dragonEggs.instantiate();
			eggInstance.name = "Dragon Eggs Minigame"
			eggScene = eggInstance;
			self.add_child(eggScene);
		GameInfo.SceneID.MANDRAKES:
			var mandrakeInstance = mandrakes.instantiate()
			mandrakeInstance.name = "Mandrakes Minigame"
			mandrakeScene = mandrakeInstance
			self.add_child(mandrakeScene);
		_:
			print("Unknown SceneID!")
		
		
	inv_panel_control(id)

func inv_panel_control(id: int):
	if id in busy_scenes:
		GameInfo.inventory.visible = false
		GameInfo.busy = true
	else:
		GameInfo.busy = false
 
