class_name DragonEgg
extends Area2D

signal eggObtained;
static var hidingSpots: Array[HidingSpot] = [
	HidingSpot.new(Vector2(-24,227), false, 0),
	HidingSpot.new(Vector2(-124,14), false, 1),
	HidingSpot.new(Vector2(408,-273), false, 4),
	HidingSpot.new(Vector2(256,319), false, 2),
	HidingSpot.new(Vector2(517,-58), false, 3),
	HidingSpot.new(Vector2(195,30), false, 1)];
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
	self.z_index = hidingSpots[index].z_index;
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
	var z_index: int;
	func _init(pos: Vector2, occupied: bool, x_index: int = 1):
		self.pos = pos;
		self.occupied = occupied;
		self.z_index = z_index;
