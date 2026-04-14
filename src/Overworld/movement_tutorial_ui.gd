extends Node2D

var startingPos: Vector2;
var shaking: bool = false;
var timer: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = self.position;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shaking:
		timer += delta;
		if timer >= 0.025:
			self.position.x *= -0.7;
			timer = 0;
		if abs(self.position.x) <= 0.1:
			shaking = false;
			self.position.x = 0;
			timer = 0;


func _on_loadingzone_reject():
	if !shaking:
		self.position.x = 1;
		self.shaking = true;
