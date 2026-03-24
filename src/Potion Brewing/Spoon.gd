extends RigidBody2D

var FOLLOW_MOUSE = false;
var RELATIVE_MOUSE_POSITION = Vector2();
var resetPositionAndRotation: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if FOLLOW_MOUSE:
		var goal = get_global_mouse_position() + RELATIVE_MOUSE_POSITION;
		
		self.linear_velocity.y += (goal - self.position).normalized().y * (1000*abs(goal.y - self.position.y)) * delta;
		self.linear_velocity.x += (goal - self.position).normalized().x * (1000*abs(goal.x - self.position.x)) * delta;
		self.linear_velocity.x = clamp(self.linear_velocity.x, -1000, 1000);
		self.linear_velocity.y = clamp(self.linear_velocity.y, -1000, 1000);
		
		if get_colliding_bodies().is_empty():
			self.constant_torque = -100000000 * self.rotation * delta;
		else:
			self.constant_torque = 0;
			#self.linear_velocity.x = clamp(self.linear_velocity.x, -100, 100);
			#self.linear_velocity.y = clamp(self.linear_velocity.y, -100, 100);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if !resetPositionAndRotation:
		resetPositionAndRotation = true;
		state.transform = Transform2D(deg_to_rad(11.6), Vector2(-220, 40));
		self.reset_physics_interpolation();
		pass

func _input_event(viewport, event, shape_idx):
	# An Area2D treats it's CollisionShap2D children as itself.
	if event is InputEventMouseButton:
		# 1 is left-click
		if event.button_index == 1:
			# A mouse press OR release.
			if event.pressed:
				self.gravity_scale = 5;
				self.linear_damp = 10;
				FOLLOW_MOUSE = true;
				RELATIVE_MOUSE_POSITION = self.position - get_global_mouse_position();
				self.center_of_mass = RELATIVE_MOUSE_POSITION;
			else:
				SoftReset();
	pass

func Reset():
	SoftReset();
	self.rotation = 11.6;
	self.position = Vector2(-195, 50);
	self.linear_velocity = Vector2.ZERO;
	self.angular_velocity = 0.0;
	resetPositionAndRotation = false;

func SoftReset():
	self.linear_damp = 0;
	self.gravity_scale = 1;
	self.constant_torque = 0;
	FOLLOW_MOUSE = false;
	self.center_of_mass = Vector2(0,300);
	RELATIVE_MOUSE_POSITION = self.position - get_global_mouse_position();


func _on_potion_brewing_click_released():
	SoftReset();
