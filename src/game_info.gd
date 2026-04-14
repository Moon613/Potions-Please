extends Node2D

@export var inventory: Inventory
var busy = false

var ruinedPotionSprite: Texture2D = preload("res://Textures/BurntPotion.png");

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
var doneMovementTutorial: bool = false;

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

# Apparently GDScript has a nested collection type restriction so the inner array cannot be Array[String], but for reference for anyone else, that is what it is.
var validRecipies: Array[Recipe] = [
	Recipe.new([HONEY, DEWDROPS, GINGER], ENERGY, 0.5, "res://Textures/EnergyElixir.png"),
	Recipe.new([MANDRAKE, LAVENDER, MILK], SLEEP, 2, "res://Textures/Sleepy Solution.png"),
	Recipe.new([SALTS, GARLIC, EGGS], STRENGTH, 1.5, "res://Textures/Strength Potion.png"),
	Recipe.new([WINGS, MOSS, SAP], HEALING, 0.75, "res://Textures/Healing Potion.png"),
	Recipe.new([ACORNS, MILK, WINGS], SHRINK, 1.25, "res://Textures/ShrinkElixir.png"),
];
# Both of these are on a scale of 0.0 - 5.0
var reputation: float = 2.5;
var energy: float = 5.0;
# -1 means that it is infinite
var resources: Dictionary[String, int] = {
	DEWDROPS: 2,
	ACORNS: 2,
	MANDRAKE: 1,
	EGGS: 1,
	SAP: 1,
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.visible = false
	pass # Replace with function body.

func _change_ingredient_amount(ingredient: String, amount: int):
	if ingredient in resources and resources[ingredient] >= 0:
		resources[ingredient] += amount;
		#update inventory panel
		inventory.add_item(ingredient, amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory") and !busy:
		inventory.visible = !inventory.visible
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
