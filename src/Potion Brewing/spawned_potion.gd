extends Sprite2D

var timer: float = 0;
var initialY: int;
var hitYGoal: bool = false;
signal potionDisappeared;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialY = self.position.y;
	potionDisappeared.connect(get_node("../UI/Brewing Progress Bar")._on_potion_disappeared);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hitYGoal:
		self.self_modulate.a = pow((1 - timer), 3);
		self.timer += 0.01;
		if self.timer >= 1:
			queue_free();
			potionDisappeared.emit();
	if !hitYGoal:
		self.position.y = lerp(initialY, -200, sqrt(1 - pow(timer - 1, 2)));
		self.timer += 0.005;
		if self.timer >= 1:
			hitYGoal = true;
			self.timer = 0;
