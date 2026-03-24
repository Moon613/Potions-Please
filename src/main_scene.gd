extends Node2D
@export var overworld: PackedScene = preload("res://Overworld/overworld.tscn")
@export var potionBrewing: PackedScene = preload("res://Potion Brewing/potion_brewing.tscn")
@export var insideHouse: PackedScene = preload("res://Overworld/inside_house.tscn")
@export var dewdrops: PackedScene = preload("res://Dewdrop Minigame/minigame.tscn")
@export var inventory: Inventory
@export var inventory_item: InventoryItem
var busy = false
@onready var morning_dew: Item = $MorningDew

var overworldScene;
var potionScene;
var insideScene;
var dewdropScene;

var dewdropsCollected = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.visible = false
	var overworldInstance = overworld.instantiate();
	overworldInstance.name = "Overworld";
	add_child(overworldInstance);
	
	var brewingInstance = potionBrewing.instantiate();
	brewingInstance.name = "Potion Brewing";
	
	var insideInstance = insideHouse.instantiate();
	insideInstance.name = "Inside House";
	
	var dewdropInstance = dewdrops.instantiate();
	dewdropInstance.name = "Dewdrop Collecting";
	
	overworldScene = overworldInstance;
	potionScene = brewingInstance;
	insideScene = insideInstance;
	dewdropScene = dewdropInstance;
	
	
	inventory.add_item(morning_dew, 8)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory") and !busy:
		inventory.visible = !inventory.visible

func _switch_scene(id: int):
	self.remove_child(self.get_children()[0]);
	match id:
		0:
			self.add_child(overworldScene)
		1:
			self.add_child(potionScene);
		2:
			self.add_child(insideScene);
		3:
			self.add_child(dewdropScene);
		_:
			print("Unknown SceneID!")
