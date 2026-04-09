extends Sprite2D

var show: bool = false;
var moveTimer: float = 0.0;
var hideTimer: float = 0.0;
const startPos: Vector2 = Vector2(0, 451);
signal IngredientDoneShowing;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if show and moveTimer < 1.0:
		self.position = lerp(startPos, Vector2(0,0), 1.0 if moveTimer == 1 else 1-pow(2, -10*moveTimer));
		moveTimer += 1 * delta;
	if moveTimer >= 1:
		self.self_modulate.a = lerp(1, 0, 1.0 if hideTimer == 1 else 1-pow(2, -10*hideTimer));
		hideTimer += 1 * delta;
	if hideTimer >= 1:
		show = false;
		moveTimer = 0;
		hideTimer = 0;
		self.position = startPos;
		IngredientDoneShowing.emit();
		self.self_modulate.a = 1;


func _on_mandrake_minigame_show_ingredient() -> void:
	print("start movie")
	show = true;
	pass # Replace with function body.
