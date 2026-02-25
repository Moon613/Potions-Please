extends Node2D
@export var overworld: PackedScene = preload("res://overworld.tscn")
@export var potionBrewing: PackedScene = preload("res://potion_brewing.tscn")
@export var insideHouse: PackedScene = preload("res://inside_house.tscn")

var overworldScene;
var potionScene;
var insideScene;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var overworldInstance = overworld.instantiate();
	overworldInstance.name = "Overworld";
	add_child(overworldInstance);
	
	var brewingInstance = potionBrewing.instantiate();
	brewingInstance.name = "Potion Brewing";
	
	var insideInstance = insideHouse.instantiate();
	insideInstance.name = "Inside House";
	
	overworldScene = overworldInstance;
	potionScene = brewingInstance;
	insideScene = insideInstance;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _switch_scene(id: int):
	self.remove_child(self.get_children()[0]);
	match id:
		0:
			self.add_child(overworldScene)
		1:
			self.add_child(potionScene);
		2:
			self.add_child(insideScene);
		_:
			print("Unknown SceneID!")
