extends Node2D
@export var overworld: PackedScene = preload("res://Overworld/overworld.tscn")
@export var potionBrewing: PackedScene = preload("res://Potion Brewing/potion_brewing.tscn")
@export var insideHouse: PackedScene = preload("res://Overworld/inside_house.tscn")
@export var dewdrops: PackedScene = preload("res://Dewdrop Minigame/minigame.tscn")
@export var mainMenu: PackedScene = preload("res://Main Menu/Main Menu.tscn")
@export var acorns: PackedScene = preload("res://Acorn Mini Game/acorn.tscn")

@export var startingScene: int = -1;

const DEWDROPS: String = "dewdrops";
const ACORNS: String = "acorns";
const HONEY: String = "honey";
const GINGER: String = "ginger";
const MANDRAKE: String = "mandrake";
const LAVENDER: String = "lavender";
const MILK: String = "milk";
const WINGS: String = "wings";

var overworldScene;
var potionScene;
var insideScene;
var dewdropScene;
var mainMenuScene;
var acornScene;

#var dewdropsCollected = 0;
#var acornsCollected = 0;
var resources: Dictionary[String, int] = {
	DEWDROPS: 2,
	ACORNS: 2,
	HONEY: -1,
	GINGER: -1
};
# Apparently GDScript has a nested collection type restriction so the inner array cannot be Array[String], but for reference for anyone else, that is what it is.
var validRecipies: Array[Recipe] = [
	Recipe.new([HONEY, DEWDROPS, GINGER], "energy", 0.5),
	Recipe.new([ACORNS, MILK, WINGS], "shrink", 1.25)
];
# Both of these are on a scale of 0.0 - 5.0
var reputation: float = 2.5;
var energy: float = 5.0;

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
	
	var acornInstance = acorns.instantiate();
	acornInstance.name = "Acorn Minigame"
	
	add_child(mainMenuInstance);
	
	overworldScene = overworldInstance;
	potionScene = brewingInstance;
	insideScene = insideInstance;
	dewdropScene = dewdropInstance;
	mainMenuScene = mainMenuInstance;
	acornScene = acornInstance;
	
	if startingScene != -1:
		_switch_scene(startingScene);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _change_ingredient_amount(ingredient: String, amount: int):
	if ingredient in resources and resources[ingredient] >= 0:
		resources[ingredient] += amount;

func _switch_scene(id: int):
	print("Switching to scene " + str(id))
	if self.get_children()[0].has_method("Reset"):
		self.get_children()[0].Reset();
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
		5:
			self.add_child(acornScene);
		_:
			print("Unknown SceneID!")

class Recipe:
	# A list of ingredients needed for this recipe
	var ingredients: Array[String];
	# The amount of energy used to make this potion.
	var energyDrain: float;
	# The name of the output potion.
	var output: String;
	func _init(ingredients: Array[String], output: String, energyDrain: float = 1):
		self.ingredients = ingredients;
		self.output = output;
		self.energyDrain = energyDrain;
