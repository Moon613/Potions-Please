class_name CreditsText
extends RichTextLabel

var start: bool = false;
var direction: int = 0;
var upTimer: float = 0;
var startPos: Vector2 = Vector2.ZERO;
var endPos: Vector2 = Vector2.ZERO;
var doneRotating: bool = false;
var sittingTimer: float = 0;
var goingDown: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start:
		if (endPos - position).length() <= 10:
			doneRotating = true;
		
		if !goingDown:
			startPos = Vector2(get_viewport_rect().end.x/2, get_viewport_rect().end.y);
			endPos = Vector2(300*direction, 324.0);
			upTimer += delta;
		
			if !doneRotating:
				self.rotation += 5 * delta * direction;
			if doneRotating:
				if abs(int(rotation_degrees))%360 <= 10:
					self.rotation = 0;
				else:
					self.rotation += 5 * delta * direction;
		
		self.position = Vector2(
			lerpf(startPos.x, endPos.x, clampf(upTimer/2, 0.0, 1.0)),
			lerpf(startPos.y, endPos.y, clampf(upTimer/2, 0.0, 1.0)));
		
		if upTimer >= 1:
			sittingTimer += delta;
		
		if sittingTimer >= 3 and !goingDown:
			goingDown = true;
		
		if goingDown:
			self.position = position.lerp(Vector2(400*direction, 0), 0.1);
