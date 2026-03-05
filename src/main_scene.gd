extends Node2D
@export var overworld: PackedScene = preload("res://Overworld/overworld.tscn")
@export var potionBrewing: PackedScene = preload("res://Potion Brewing/potion_brewing.tscn")
@export var insideHouse: PackedScene = preload("res://Overworld/inside_house.tscn")
@export var dewdrops: PackedScene = preload("res://Dewdrop Minigame/minigame.tscn")
@export var mainMenu: PackedScene = preload("res://Main Menu/Main Menu.tscn")

var overworldScene;
var potionScene;
var insideScene;
var dewdropScene;
var mainMenuScene;

var dewdropsCollected = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var overworldInstance = overworld.instantiate();
	overworldInstance.name = "Overworld";
	
	var brewingInstance = potionBrewing.instantiate();
	brewingInstance.name = "Potion Brewing";
	
	var insideInstance = insideHouse.instantiate();
	insideInstance.name = "Inside House";
	
	var dewdropInstance = dewdrops.instantiate();
	dewdropInstance.name = "Dewdrop Collecting";
	
	var mainMenuInstance = mainMenu.instantiate();
	mainMenuInstance.name = "Main Menu";
	
	add_child(mainMenuInstance);
	
	overworldScene = overworldInstance;
	potionScene = brewingInstance;
	insideScene = insideInstance;
	dewdropScene = dewdropInstance;
	mainMenuScene = mainMenuInstance;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _switch_scene(id: int):
	print("Switching to scene " + str(id))
	self.remove_child(self.get_children()[0]);
	match id:
		0:
			self.add_child(overworldScene);
		1:
			self.add_child(potionScene);
		2:
			self.add_child(insideScene);
		3:
			self.add_child(dewdropScene);
		4:
			self.add_child(mainMenuScene);
		_:
			print("Unknown SceneID!")
