extends RigidBody2D

var FOLLOW_MOUSE = false;
var RELATIVE_MOUSE_POSITION = Vector2();

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if FOLLOW_MOUSE:
		var goal = get_global_mouse_position() + RELATIVE_MOUSE_POSITION;
		
		self.linear_velocity.y += (goal - self.position).normalized().y * (1000*abs(goal.y - self.position.y)) * delta;
		self.linear_velocity.x += (goal - self.position).normalized().x * (1000*abs(goal.x - self.position.x)) * delta;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input_event(viewport, event, shape_idx):
	# An Area2D treats it's CollisionShap2D children as itself.
	if event is InputEventMouseButton:
		# 1 is left-click
		if event.button_index == 1:
			# A mouse press OR release.
			if event.pressed:
				self.gravity_scale = 50;
				self.linear_damp = 10;
				FOLLOW_MOUSE = true;
				RELATIVE_MOUSE_POSITION = self.position - get_global_mouse_position();
			else:
				self.linear_damp = 0;
				self.gravity_scale = 1;
				FOLLOW_MOUSE = false;
	pass
