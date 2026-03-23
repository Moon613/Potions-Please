extends Node2D

const DEWDROPS: String = "dewdrops";
const ACORNS: String = "acorns";
const HONEY: String = "honey";
const GINGER: String = "ginger";
const MANDRAKE: String = "mandrake";
const LAVENDER: String = "lavender";
const MILK: String = "milk";
const WINGS: String = "wings";

# Apparently GDScript has a nested collection type restriction so the inner array cannot be Array[String], but for reference for anyone else, that is what it is.
var validRecipies: Array[Recipe] = [
	Recipe.new([HONEY, DEWDROPS, GINGER], "energy", 0.5),
	Recipe.new([ACORNS, MILK, WINGS], "shrink", 1.25)
];
# Both of these are on a scale of 0.0 - 5.0
var reputation: float = 2.5;
var energy: float = 5.0;
var resources: Dictionary[String, int] = {
	DEWDROPS: 2,
	ACORNS: 2,
	HONEY: -1,
	GINGER: -1
};

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _change_ingredient_amount(ingredient: String, amount: int):
	if ingredient in resources and resources[ingredient] >= 0:
		resources[ingredient] += amount;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
