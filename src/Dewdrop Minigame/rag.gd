extends Area2D

signal collectedDrop;

var FOLLOW_MOUSE = false;
var RELATIVE_MOUSE_POSITION = Vector2();
var fading = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	if !fading and event is InputEventMouseButton:
		if event.button_index == 1:
			print("Pressed")
			print(event.pressed)
			if event.pressed:
				FOLLOW_MOUSE = true;
				RELATIVE_MOUSE_POSITION = self.position - get_global_mouse_position();
			else:
				FOLLOW_MOUSE = false;

func _on_minigame_transition_to_drying():
	fading = true;
	FOLLOW_MOUSE = false;
