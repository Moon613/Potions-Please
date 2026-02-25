extends Node2D
@export var overworld: PackedScene = preload("res://overworld.tscn")
@export var potionBrewing: PackedScene = preload("res://potion_brewing.tscn")

var overworldScene;
var potionScene;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var overworldInstance = overworld.instantiate();
	overworldInstance.name = "Overworld";
	add_child(overworldInstance);
	var brewingInstance = potionBrewing.instantiate();
	brewingInstance.name = "Potion Brewing";
	
	overworldScene = overworldInstance;
	potionScene = brewingInstance;
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
		_:
			print("Unknown SceneID!")
