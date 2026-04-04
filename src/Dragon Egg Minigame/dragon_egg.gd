class_name DragonEgg
extends Area2D

signal eggObtained;
static var hidingSpots: Array[HidingSpot] = [
	HidingSpot.new(Vector2(-256,-128), false),
	HidingSpot.new(Vector2(-384,192), false),
	HidingSpot.new(Vector2(128,-64), false),
	HidingSpot.new(Vector2(256,128), false)];
var timer: float = 0;
var currentHidingSpot: int = -1;
var mouseOver: bool = false;
@export var timeToSwitchHidingSpot: int = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	SelectRandomHidingSpot();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta;
	if timer >= timeToSwitchHidingSpot:
		SelectRandomHidingSpot();
		timer = 0;

func SelectRandomHidingSpot():
	if currentHidingSpot != -1:
		hidingSpots[currentHidingSpot].occupied = false;
		
	var index: int = randi_range(0, hidingSpots.size()-1);
	while hidingSpots[index].occupied:
		index = randi_range(0, hidingSpots.size()-1);
	currentHidingSpot = index;
	self.position = hidingSpots[index].pos;
	hidingSpots[index].occupied = true;

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed and mouseOver:
		eggObtained.emit();
		queue_free();

func _on_mouse_entered() -> void:
	mouseOver = true;

func _on_mouse_exited() -> void:
	mouseOver = false;

class HidingSpot:
	var pos: Vector2;
	var occupied: bool;
	func _init(pos: Vector2, occupied: bool):
		self.pos = pos;
		self.occupied = occupied;
