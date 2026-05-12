extends Area2D
@export var dewdrop: PackedScene = preload("res://Dewdrop Minigame/dewdrop.tscn")

signal collectedDrop;
signal RagReappearing;

var FOLLOW_MOUSE = false;
var mouseInitialGarbPos: Vector2 = Vector2.ZERO;
var movingOffscreen = false;
var fadeTimer = 0.1;
var reappearing = false;
var startPos: Vector2;
var farthestStretch: float = 1.0;
var inSecondPart: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if movingOffscreen: 
		if fadeTimer < 1:
			self.position.y = lerpf(startPos.y, 1000, 0.0 if fadeTimer == 0 else pow(2, 10 * fadeTimer - 10));
			fadeTimer += 1 * delta;
		else:
			$AnimatedSprite2D.frame = 1;
			movingOffscreen = false;
			reappearing = true;
			RagReappearing.emit();
			inSecondPart = true;
			fadeTimer = 0;
			startPos = self.position;
	if reappearing and fadeTimer < 1:
			$AnimatedSprite2D.material.set_shader_parameter("open", false);
			self.position = lerp(startPos, Vector2(0,-80), 1.0 if fadeTimer == 1 else 1-pow(2, -10*fadeTimer));
			fadeTimer += 1 * delta;
	
	if !inSecondPart:
		for body: Node2D in get_overlapping_bodies():
			if body.is_in_group("Dewdrop") and ContainsDewdrop(body):
				body.queue_free();
				collectedDrop.emit();
				var wetness = $AnimatedSprite2D.material.get_shader_parameter("wetness");
				$AnimatedSprite2D.material.set_shader_parameter("wetness", wetness + (0.4/self.get_parent().number_of_dewdrops));
	

func _physics_process(delta):
	if FOLLOW_MOUSE:
		var goal = get_global_mouse_position() + mouseInitialGarbPos;
		self.position = goal;
	pass

func _input_event(viewport, event, shape_idx):
	if !movingOffscreen and !reappearing and event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			FOLLOW_MOUSE = true;
			mouseInitialGarbPos = self.position - get_global_mouse_position();
		else:
			FOLLOW_MOUSE = false;

func ContainsDewdrop(dewdrop: Node2D):
	# All nodes in the Dewdrop group should be RigidBody2D and have a shape.
	var rect = dewdrop.get_node("CollisionShape2D").shape.get_rect() as Rect2;
	
	var dewDropPos = dewdrop.position + rect.position;
	var ragPos = position + $CollisionShape2D.shape.get_rect().position;
	var dewDropEnd = dewdrop.position + rect.end;
	var ragEnd = position + $CollisionShape2D.shape.get_rect().end;
	
	return dewDropPos.x > ragPos.x and dewDropPos.y > ragPos.y and dewDropEnd.x < ragEnd.x and dewDropEnd.y < ragEnd.y;

func _on_minigame_transition_to_drying():
	startPos = self.position;
	movingOffscreen = true;
	FOLLOW_MOUSE = false;

func _on_arrow_success():
	SpawnDroplet(Vector2.ZERO);

func _on_arrow_faliure():
	var X: int = randi_range(300, 1400);
	X *= -1 if randi_range(0,1) == 0 else 1;
	SpawnDroplet(Vector2(X, -500), 1)

func SpawnDroplet(initialDirection: Vector2, z_index: int = 0):
	$AnimatedSprite2D.material.set_shader_parameter("wetness", lerp(1.0, 0.4, (float(get_parent().timingSuccesses) / float(get_parent().maximumSliderAttempts+1))));
	var drop = dewdrop.instantiate();
	drop.name = "Dewdrop";
	drop.gravity_scale = 1;
	drop.linear_velocity = initialDirection;
	drop.z_index = z_index;
	get_parent().add_child(drop);
	$RagSqueezePlayer.play("Rag Squeeze");

func _on_rag_squeeze_player_animation_finished(anim_name):
	if anim_name == "Rag Squeeze":
		$RagSqueezePlayer.play("Rag Unsqueeze");
