class_name CreditsText
extends RichTextLabel

var start: bool = false;
var direction: int = 0;
var upTimer: float = 0;
var startPos: Vector2 = Vector2.ZERO;
var endPos: Vector2 = Vector2.ZERO;
var sittingTimer: float = 0;
var goingUp: bool = false;
var startRotation: float = 0;
var flyAwayTimer: float = 0;
const XDist: int = 400;
const SIT_TIME: int = 2;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start:
		if !goingUp and sittingTimer == 0:
			startPos = Vector2(get_viewport_rect().end.x/2, get_viewport_rect().end.y);
			self.visible = true;
			upTimer += delta;
			var x1 = sin(((upTimer/2) * PI) / 2);
			var x2 = 1 - pow(1 - (upTimer/2), 4);
			self.rotation_degrees = lerpf(startRotation, 0.0, clampf(x1, 0.0, 1.0));
			self.position = Vector2(
				lerpf(startPos.x, endPos.x, clampf(x1, 0.0, 1.0)),
				lerpf(startPos.y, endPos.y, clampf(x2, 0.0, 1.0)));
		
		if upTimer/2 >= 1:
			sittingTimer += delta;
		
		if sittingTimer >= SIT_TIME and !goingUp:
			goingUp = true;
			startPos = self.position;
		
		if goingUp:
			flyAwayTimer += delta;
			var x: float = flyAwayTimer/0.75;
			self.position.y = lerpf(startPos.y, -50, 0 if x == 0 else pow(2, 10*x-10));
			self.position.x = lerpf(startPos.x, startPos.x + 75*-direction, 1 if x == 1 else 1 - pow(2, -10*x));
			self.rotation_degrees = lerp(0, 90*direction, 0 if x == 0 else pow(2, 10*x-10));
			if self.position.y <= -50:
				queue_free();

func Setup(direction: int, screenRect: Rect2, text: String):
	self.text = "[center]"+text+"[/center]";
	const TIMES_TO_SPIN: int = 2;
	self.direction = direction;
	self.start = true;
	startRotation = 360 * TIMES_TO_SPIN * direction;
	endPos = Vector2(screenRect.size.x/2 - self.size.x/2 + XDist*direction, screenRect.size.y/2);
	self.position = Vector2(get_viewport_rect().end.x/2, get_viewport_rect().end.y);
