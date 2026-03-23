@tool
extends RigidBody2D

@export var Sprite: Texture2D
@export var Shape : Shape2D
# This should match something in main_scene.gd's resource Dictionary.
@export var Type: String

var movable: bool = false;
var mouseOffset: Vector2;
var beingMoved: bool = false;
var locked: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = Sprite;
	$CollisionShape2D.shape = Shape;
	# Prevents from running in editor to stop errors, and only works if the parent has the correct signal.
	if !Engine.is_editor_hint() and get_parent().has_signal("clickReleased"):
		get_parent().clickReleased.connect(released);
	# Have to do the connection here because duplicate() does not copy incoming signals
	for child in get_parent().get_children().filter(func(child: Node2D): return child.is_in_group("Cauldron Inside Hitbox")):
		child.StartStirring.connect(_on_start_stirring);

func _physics_process(delta: float) -> void:
	if beingMoved:
		var goal = get_global_mouse_position() + mouseOffset;
		
		if (goal-self.position).length() >= 100:
			self.linear_velocity += lerp(Vector2.ZERO, goal - self.position, clampf(((goal-self.position).length())*delta, 0, INF)).clampf(-200, 200);
			#self.linear_velocity.x = clamp(self.linear_velocity.x, -500, 500);
			#self.linear_velocity.y = clamp(self.linear_velocity.y, -500, 500);
		else:
			self.linear_velocity = (goal-self.position)*10
		
		var collision: KinematicCollision2D = KinematicCollision2D.new();
		if self.test_move(self.transform, self.linear_velocity*delta, collision, 1.5) and collision.get_collider().get_class() == "RigidBody2D":
			var bodyHit: RigidBody2D = collision.get_collider();
			bodyHit.apply_impulse(self.linear_velocity * (self.mass/bodyHit.mass), self.position-bodyHit.position);
			self.linear_velocity = self.linear_velocity.bounce(collision.get_normal()).clampf(-300, 300);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		var root = get_tree().current_scene;
		if movable:
			mouseOffset = self.position - get_global_mouse_position();
			beingMoved = true;
			self.gravity_scale = 0.0;
		elif Type in GameInfo.resources and ((GameInfo.resources[self.Type] > 0 and get_parent().spawnedIngredients[self.Type] < GameInfo.resources[self.Type]) or GameInfo.resources[self.Type] < 0):
			var copy = self.duplicate();
			copy.movable = true;
			copy.mouseOffset = Vector2.ZERO;
			copy.freeze = false;
			copy.collision_mask = 1;
			copy.collision_layer = 1;
			copy.beingMoved = true;
			get_parent().add_child(copy);
			get_parent().spawnedIngredients[self.Type] += 1;

func released():
	if beingMoved:
		beingMoved = false;
		self.gravity_scale = 1.0;

func _on_start_stirring():
	if movable:
		queue_free();
	else:
		self.freeze = true;
		self.collision_layer = 0;
		self.collision_mask = 0;
