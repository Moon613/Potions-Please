extends Node2D

signal ReturnToOverworld(id: int);
signal ChangeIngredients(ingr: String, amt: int);
@export var numberOfTapSpots: int = 4;
var tapSpot: PackedScene = preload("res://Treesap Minigame/Tap Spot.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	ChangeIngredients.connect(GameInfo._change_ingredient_amount);
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);
	var spawnedSpots: Array[Node2D] = [];
	for i: int in numberOfTapSpots:
		var tapInstance: Node2D = tapSpot.instantiate();
		var pos = Vector2(randi_range(-160, 160), randi_range(-288, 288));
		while !spawnedSpots.filter(func(spot): return (spot.position - pos).length() < 128).is_empty():
			pos = Vector2(randi_range(-160, 160), randi_range(-288, 288));
		tapInstance.position = pos;
		tapInstance.name = "Tap" + str(i);
		tapInstance.add_to_group("Tree Tap Spot");
		add_child(tapInstance);
		spawnedSpots.append(tapInstance);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Reset():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ReturnToOverworld.emit(0);
