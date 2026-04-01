extends Area2D

var closestNodePos: Vector2;
var timer: int = -1;
var timeToStop: int = 0;
signal SapCollected(resourceAmount: int);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	const MAX_INGREDIENTS_RETURNED: int = 3;
	if timer >= 0:
		timer += 1;
	if timer >= timeToStop:
		SapCollected.emit(round(MAX_INGREDIENTS_RETURNED * (1.0 - clamp((self.position - closestNodePos).length() / 200.0, 0.0, 1.0))));
		timer = -1;

func _on_drain_taps():
	const MAX_TIME_ANIMATION_PLAYS: float = 20.0;
	$AnimatedSprite2D.play();
	timeToStop = MAX_TIME_ANIMATION_PLAYS * (1.0 - clamp((self.position - closestNodePos).length() / 200.0, 0.0, 1.0));
