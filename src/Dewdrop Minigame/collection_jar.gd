extends Area2D
signal DoneMoveDown;
signal CollectedDrop;

var moveIn = false;
var moveTimer = -1;
var startPos: Vector2;
var moveOut = false;
var collectingDroplets: bool = false;

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
			collectingDroplets = true;
	if moveOut:
		if moveTimer < 1:
			self.position = lerp(startPos, Vector2(0, 800), 0.0 if moveTimer == 0 else pow(2, 10*moveTimer-10));
			moveTimer += 1 * delta;
		else:
			moveOut = false;
			DoneMoveDown.emit();
	
	if collectingDroplets:
		var overlapping = self.get_overlapping_bodies().filter(func(child: Node2D): return child.is_in_group("Dewdrop"));
		for child in overlapping:
			child.queue_free();
			CollectedDrop.emit();


func _on_minigame_transition_to_drying():
	moveIn = true;
	startPos = self.position;


func _on_minigame_remove_jar():
	moveOut = true;
	moveTimer = 0;
	startPos = self.position;
