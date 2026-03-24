extends Node2D

@export var numberOfTapSpots: int = 4;
var tapSpot: PackedScene = preload("res://Treesap Minigame/Tap Spot.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	for i: int in numberOfTapSpots:
		var tapInstance = tapSpot.instantiate();
		tapInstance.position = Vector2(randi_range(-160, 160), randi_range(-288, 288));
		tapInstance.name = "Tap" + str(i);
		add_child(tapInstance);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
