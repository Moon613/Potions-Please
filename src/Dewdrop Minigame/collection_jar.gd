extends Sprite2D

var moveIn = false;
var moveTimer = -1;
var startPos: Vector2;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moveIn:
		if moveTimer < 1:
			self.position = lerp(startPos, Vector2(0,300), 1.0 if moveTimer == 1 else 1-pow(2, -10*moveTimer));
			moveTimer += 0.025;
		else:
			moveIn = false;


func _on_minigame_transition_to_drying():
	moveIn = true;
	startPos = self.position;
