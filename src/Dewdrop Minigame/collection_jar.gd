extends AnimatedSprite2D
signal DoneMoveDown;

var moveIn = false;
var moveTimer = -1;
var startPos: Vector2;
var moveOut = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moveIn:
		if moveTimer < 1:
			self.position = lerp(startPos, Vector2(0,300), 1.0 if moveTimer == 1 else 1-pow(2, -10*moveTimer));
			moveTimer += 1 * delta;
		else:
			moveIn = false;
	if moveOut:
		if moveTimer < 1:
			self.position = lerp(startPos, Vector2(0, 800), 0.0 if moveTimer == 0 else pow(2, 10*moveTimer-10));
			moveTimer += 1 * delta;
		else:
			moveOut = false;
			DoneMoveDown.emit();


func _on_minigame_transition_to_drying():
	moveIn = true;
	startPos = self.position;


func _on_minigame_remove_jar():
	moveOut = true;
	moveTimer = 0;
	startPos = self.position;
