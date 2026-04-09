extends Node2D

signal ReturnToOverworld(id: int);
signal ChangeIngredients(ingr: String, amt: int);
signal DrainTaps;
signal ShowIngredient;
@export var numberOfTapSpots: int = 4;
var tapSpot: PackedScene = preload("res://Treesap Minigame/Tap Spot.tscn");
var tap: PackedScene = preload("res://Treesap Minigame/tap.tscn");
var tapsPlaced: int = 0;
var resourceAmountCollected: int = 0;
var tapsFinishedCollecting: int = 0;
var triggeredPopup: bool = false;
var closedPopup: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():	
	Input.warp_mouse(get_viewport_rect().size * 0.5);
	ChangeIngredients.connect(GameInfo._change_ingredient_amount);
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);
	PlaceTapSpots();
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !triggeredPopup:
		$Tutorial.popup();
		$Tutorial.move_to_center();
		triggeredPopup = true;
	if closedPopup:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	if tapsPlaced >= numberOfTapSpots:
		DrainTaps.emit();
		tapsPlaced = 0;
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

func PlaceTapSpots():
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

func Reset():
	$TapControl.canPlaceMoretaps = true;
	$TapControl.visible = true;
	for child in get_children().filter(func(obj: Node2D): return obj.is_in_group("Tap") or obj.is_in_group("Tree Tap Spot")):
		child.queue_free();
	tapsPlaced = 0;
	resourceAmountCollected = 0;
	tapsFinishedCollecting = 0;
	PlaceTapSpots();
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ReturnToOverworld.emit(0);
		self.queue_free()

func _on_tap_control_place_tap(placedTapSpot: Vector2) -> void:
	var tapInstance = tap.instantiate();
	tapInstance.add_to_group("Tap");
	tapInstance.set_script(load("res://Treesap Minigame/tap.gd"))
	tapInstance.position = placedTapSpot;
	DrainTaps.connect(tapInstance._on_drain_taps);
	tapInstance.SapCollected.connect(self._on_tap_sap_collection);
	add_child(tapInstance);
	tapsPlaced += 1;
	var closestTapSpot: Node2D = null;
	for child in get_children().filter(func(c): return c.is_in_group("Tree Tap Spot")):
		if closestTapSpot == null or (child.position - placedTapSpot).length() < (closestTapSpot.position - placedTapSpot).length():
			closestTapSpot = child;
	closestTapSpot.add_to_group("Already Tapped");
	tapInstance.closestNodePos = closestTapSpot.position;

func _on_tap_sap_collection(resourceAmount: int):
	tapsFinishedCollecting += 1;
	resourceAmountCollected += resourceAmount;
	if tapsFinishedCollecting >= numberOfTapSpots:
		ShowIngredient.emit();

func _on_ingredient_done_showing():
	ChangeIngredients.emit("sap", resourceAmountCollected);
	ReturnToOverworld.emit(0);
	self.queue_free()


func _on_tutorial_popup_hide() -> void:
	closedPopup = true
	pass # Replace with function body.
