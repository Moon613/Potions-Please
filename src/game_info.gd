extends Node2D

@onready var inventory: Inventory = $Inventory/Inventory
@onready var inventoryButton = $"Inventory/Inventory Button"
@onready var pause_menu: CanvasLayer = $"Pause Menu"
@export var book_layer: CanvasLayer
var busy: bool = false
var journal_is_open: bool = false;

var ruinedPotionSprite: Texture2D = preload("res://Potion Brewing/Textures/Burnt Potion (NEW).png");

# Flags for saving various states
var dewdropTutorial: bool = true
var acornsTutorial: bool = true
var dragoneggTutorial: bool = true
var treesapTutorial: bool = true
var mandrakeTutorial: bool = true

# Flags for movement "tutorial"
var directionTutorial: Dictionary[String, bool] = {
	"w": false,
	"s": false,
	"a": false,
	"d": false
}
var seenMorganaNote: bool = false;
var doneMovementTutorial: bool = false;
var leftHouseForFirstTime: bool = false;
var finishedGatheringTutorial: bool = false;
var reenteredHouse: bool = false;

# Flag for keeping track of which quest is currently active
@export var currentQuest: PotionQuests;
enum PotionQuests {
	NONE = 0,
	ENERGY = 1,
	SLEEP = 2,
	STRENGTH = 3,
	HEALING = 4,
	SHRINK = 5
}
var questToRequiredPotion: Dictionary[PotionQuests, String] = {
	PotionQuests.ENERGY: ENERGY,
	PotionQuests.SLEEP: SLEEP,
	PotionQuests.STRENGTH: STRENGTH,
	PotionQuests.HEALING: HEALING,
	PotionQuests.SHRINK: SHRINK
};

# Energy amounts for minigames, by scne ID
var minigameEnergy: Dictionary[int, float] = {
	# Technically not a minigame, potion brewing. Per potion.
	1: 0.5,
	# Dewdrop collection
	3: 0.5,
	# Acorns
	5: 1.0,
	# Sap tapping
	6: 0.75,
	# Dragon Egg hunt
	7: 1.5,
	# Mandrake wack-a-mole
	8: 1.0
};

# Scene IDs
enum SceneID {
	OVERWORLD = 0,
	POTIONBREWING = 1,
	INSIDEHOUSE = 2,
	DEWDROPS = 3,
	MAINMENU = 4,
	ACORNS = 5,
	TREESAP = 6,
	DRAGONEGGS = 7,
	MANDRAKES = 8
}

# Ingredients
	# Minigame
const ACORNS: String = "acorns";
const DEWDROPS: String = "dewdrops";
const MANDRAKE: String = "mandrake";
const EGGS: String = "eggs";
const SAP: String = "sap";
	# Infinite
const MOSS: String = "moss";
const HONEY: String = "honey";
const GINGER: String = "ginger";
const LAVENDER: String = "lavender";
const MILK: String = "milk";
const SALTS: String = "salts";
const GARLIC: String = "garlic";
const WINGS: String = "wings";

# Potions
const ENERGY: String = "energy";
const SLEEP: String = "sleep";
const STRENGTH: String = "strength";
const HEALING: String = "healing";
const SHRINK: String = "shrink";
const RUINED: String = "burnt";

var potionToImage: Dictionary[String, String] = {
	ENERGY: "res://Potion Brewing/Textures/Energy Elixir(NEW).png",
	SLEEP: "res://Potion Brewing/Textures/Sleepy Solution.png",
	STRENGTH: "res://Potion Brewing/Textures/Strength Potion.png",
	HEALING: "res://Potion Brewing/Textures/Healing Potion.png",
	SHRINK: "res://Potion Brewing/Textures/ShrinkElixir.png",
	RUINED: "res://Potion Brewing/Textures/BurntPotion.png"
};

# Apparently GDScript has a nested collection type restriction so the inner array cannot be Array[String], but for reference for anyone else, that is what it is.
var validRecipies: Array[Recipe] = [
	Recipe.new([HONEY, DEWDROPS, GINGER], ENERGY, 0.5, "res://Potion Brewing/Textures/Energy Elixir(NEW).png"),
	Recipe.new([MANDRAKE, LAVENDER, MILK], SLEEP, 2, "res://Potion Brewing/Textures/Sleepy Solution.png"),
	Recipe.new([SALTS, GARLIC, EGGS], STRENGTH, 1.5, "res://Potion Brewing/Textures/Strength Potion.png"),
	Recipe.new([WINGS, MOSS, SAP], HEALING, 0.75, "res://Potion Brewing/Textures/Healing Potion.png"),
	Recipe.new([ACORNS, MILK, WINGS], SHRINK, 1.25, "res://Potion Brewing/Textures/ShrinkElixir.png"),
];
# Both of these are on a scale of 0.0 - 5.0
@export var reputation: float = 2.5;
@export var energy: float = 2.5;
# -1 means that it is infinite
var resources: Dictionary[String, int] = {
	DEWDROPS: 0,
	ACORNS: 0,
	MANDRAKE: 0,
	EGGS: 0,
	SAP: 0,
	MOSS: -1,
	HONEY: -1,
	GINGER: -1,
	LAVENDER: -1,
	MILK: -1,
	SALTS: -1,
	GARLIC: -1,
	WINGS: -1
};
# Completed potions
var potions: Dictionary[String, int] = {
	ENERGY: 0,
	SLEEP: 0,
	STRENGTH: 0,
	HEALING: 0,
	SHRINK: 0,
	RUINED: 0
}

func ProgressToNextPotionQuest():
	return randi_range(1, PotionQuests.size()-1);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.visible = false
	pause_menu.visible = false
	pass # Replace with function body.

func _change_ingredient_amount(ingredient: String, amount: int):
	if ingredient in resources and resources[ingredient] >= 0:
		resources[ingredient] += amount;
		#update inventory panel
		inventory.add_item(ingredient, amount)

func add_potion(potion: String):
	potions[potion] += 1
	inventory.add_item(potion, 1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if Input.is_action_just_pressed("inventory"):
		_on_inventory_button_pressed();

func reset_info():
	for pot in potions.keys():
		potions[pot] = 0
	for res in resources.keys():
		if resources[res] != -1:
			resources[res] = 0
	busy = true
	reputation = 2.5
	energy = 1
	
	dewdropTutorial = true
	acornsTutorial = true
	dragoneggTutorial = true
	treesapTutorial = true
	mandrakeTutorial = true

	for key in directionTutorial.keys():
		directionTutorial[key] = false
		
	doneMovementTutorial = false;
	leftHouseForFirstTime = false;
	finishedGatheringTutorial = false;
	
	inventory.clear_inventory()
	pass

class Recipe:
	# A list of ingredients needed for this recipe
	var ingredients: Array[String];
	# The amount of energy used to make this potion.
	var energyDrain: float;
	# The name of the output potion.
	var output: String;
	# The image of the resulting potion
	var image: Texture2D;
	func _init(ingredients: Array[String], output: String, energyDrain: float = 1, pathToImage: String = "res://Textures/EnergyElixir.png"):
		self.ingredients = ingredients;
		self.output = output;
		self.image = load(pathToImage);
		self.energyDrain = energyDrain;

# a collection of variables to save
func save():
	var save_dict = {
		#stats
		"reputation": reputation,
		"energy": energy,
		#"pos_x": position.x,
		#"pos_y": position.y,
		
		# resources
		"resources": resources,
		#"dewdrops": resources[DEWDROPS],
		#"acorns": resources[ACORNS],
		#"mandrake": resources[MANDRAKE],
		#"eggs": resources[EGGS],
		#"sap": resources[SAP],
		
		# potions
		"potions": potions,
		#"energy": potions[ENERGY],
		#"sleep": potions[SLEEP],
		#"strength": potions[STRENGTH],
		#"healing": potions[HEALING],
		#"shrink": potions[SHRINK],
		#"ruined": potions[RUINED],
		
		# tutorial flags
		"dewdropTutorial": dewdropTutorial,
		"acornsTutorial": acornsTutorial,
		"dragoneggTutorial": dragoneggTutorial,
		"treesapTutorial": treesapTutorial,
		"mandrakeTutorial": mandrakeTutorial,
		
		"directionTutorial": directionTutorial,
		"doneMovementTutorial": doneMovementTutorial,
		"leftHouseForFirstTime": leftHouseForFirstTime,
		"finishedGatheringTutorial": finishedGatheringTutorial,
		
		# story flags
		"currentQuest": currentQuest
	}
	return save_dict

func set_dict(dict_name, dict_data):
	var target_dict
	if dict_name == "directionTutorial":
		target_dict = directionTutorial
		pass
	if dict_name == "resources":
		target_dict = resources
		pass
	if dict_name == "potions":
		target_dict = potions
		pass
	for i in dict_data:
		target_dict[i] = dict_data[i]

func _on_inventory_journal_open() -> void:
	book_layer.visible = true

func _on_inventory_button_pressed():
	if !busy and !get_tree().paused:
		inventory.visible = !inventory.visible;

func IsInventoryOpen():
	return $Inventory/Inventory.visible;
