@tool
extends PointLight2D

var maxTo: float = 0.9;
var minTo: float = 0.6;
var timer: int = 0;
@export var startingTo: float = 0.8;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxTo = 1.0;
	minTo = 0.5;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += 1;
	if timer % randi_range(15, 20) == 0:
		self.energy = clamp(self.energy + randf_range(-0.1, 0.2), 0.3, 1.1);
	if timer % 10 == 0:
		self.texture.fill_to.x = clamp(self.texture.fill_to.x + randf_range(-0.15, 0.5), minTo, maxTo);
