class_name DragonEgg
extends Area2D

static var hidingSpots: Array[HidingSpot] = [
	HidingSpot.new(Vector2(-256,-128), false),
	HidingSpot.new(Vector2(-384,192), false),
	HidingSpot.new(Vector2(128,-64), false),
	HidingSpot.new(Vector2(256,128), false)];
var timer: float = 0;
var currentHidingSpot: int = -1;
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


class HidingSpot:
	var pos: Vector2;
	var occupied: bool;
	func _init(pos: Vector2, occupied: bool):
		self.pos = pos;
		self.occupied = occupied;
