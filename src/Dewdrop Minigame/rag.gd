extends Area2D

signal collectedDrop;

var FOLLOW_MOUSE = false;
var RELATIVE_MOUSE_POSITION = Vector2();
var fading = false;
var fadeTimer = 0.1;
var reappearing = false;
var startPos: Vector2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fading: 
		if fadeTimer < 1:
			self.position.y = lerpf(startPos.y, 1000, 0.0 if fadeTimer == 0 else pow(2, 10 * fadeTimer - 10));
			fadeTimer += 0.025;
		else:
			$AnimatedSprite2D.frame = 1;
			fading = false;
			reappearing = true;
			fadeTimer = 0;
			startPos = self.position;
	if reappearing:
		if fadeTimer < 1:
			self.position = lerp(startPos, Vector2(0,-200), 1.0 if fadeTimer == 1 else 1-pow(2, -10*fadeTimer));
			fadeTimer += 0.025;
	for body in get_overlapping_bodies():
		if body is RigidBody2D and body.name.contains("Dewdrop"):
			var collider = body.get_node("CollisionShape2D");
			if collider.shape is CircleShape2D:
				# Math... Evil math...
				var circleCenter: Vector2 = body.position;
				var radius: int = collider.shape.radius;
				var ragCenter: Vector2 = self.position;
				var ragSizeX: int = self.get_node("CollisionShape2D").shape.size.x / 2;
				var ragSizeY: int = self.get_node("CollisionShape2D").shape.size.y / 2;
				
				var circleLeft = circleCenter.x - radius;
				var circleRight = circleCenter.x + radius;
				var circleTop = circleCenter.y - radius;
				var circleBottom = circleCenter.y + radius;
				var ragLeft = ragCenter.x - ragSizeX;
				var ragRight = ragCenter.x + ragSizeX;
				var ragTop = ragCenter.y - ragSizeY;
				var ragBottom = ragCenter.y + ragSizeY;
				if circleLeft > ragLeft and circleRight < ragRight and circleTop > ragTop and circleBottom < ragBottom:
					body.queue_free();
					collectedDrop.emit();
	pass

func _physics_process(delta):
	if FOLLOW_MOUSE:
		var goal = get_global_mouse_position() + RELATIVE_MOUSE_POSITION;
		self.position = goal;
	pass

func _input_event(viewport, event, shape_idx):
	if !fading and !reappearing and event is InputEventMouseButton:
		if event.button_index == 1:
			print("Pressed")
			print(event.pressed)
			if event.pressed:
				FOLLOW_MOUSE = true;
				RELATIVE_MOUSE_POSITION = self.position - get_global_mouse_position();
			else:
				FOLLOW_MOUSE = false;
	elif reappearing and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		pass

func _on_minigame_transition_to_drying():
	startPos = self.position;
	fading = true;
	FOLLOW_MOUSE = false;
