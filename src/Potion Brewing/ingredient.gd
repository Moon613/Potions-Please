@tool
class_name BrewingIngredient
extends RigidBody2D

@export var Sprite: Texture2D
@export var Shape : Shape2D
# This should match something in main_scene.gd's resource Dictionary.
@export var Type: String

signal NotEnoughEnergyForBrewing;

var movable: bool = false;
var mouseOffset: Vector2;
var beingMoved: bool = false;
var mouseOver: bool = false;
static var picked: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = Sprite;
	$CollisionShape2D.shape = Shape;
	for child in get_parent().get_children().filter(func(child: Node2D): return child.is_in_group("Cauldron Inside Hitbox")):
		child.StartStirring.connect(_on_start_stirring);
	if !Engine.is_editor_hint():
		# Prevents from running in editor to stop errors, and only works if the parent has the correct signal.
		if get_parent().has_signal("clickReleased"):
			# Have to do the connection here because duplicate() does not copy incoming signals
			get_parent().clickReleased.connect(released);
		$Text.tooltip_text = Type.capitalize();
		$Text.size = $CollisionShape2D.shape.get_rect().size;
		$Text.position = $CollisionShape2D.shape.get_rect().size*-0.5;

func _physics_process(delta: float) -> void:
	if beingMoved:
		if (get_global_mouse_position() - self.global_position).length() >= max(0.1*self.linear_velocity.length(), 20):
			self.linear_velocity += (get_global_mouse_position() - self.global_position).normalized() * 10000 * delta;
		else:
			self.linear_velocity = self.linear_velocity.lerp(Vector2.ZERO, 0.2);
		if self.linear_velocity.length() > 2000:
			self.linear_velocity = self.linear_velocity.normalized() * 2000;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Engine.is_editor_hint():
		if GameInfo.resources[self.Type] == 0:
			self.freeze = true;
		

func _unhandled_input(event: InputEvent) -> void:
	if mouseOver and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		if movable:
			mouseOffset = self.position - get_global_mouse_position();
			beingMoved = true;
			self.gravity_scale = 0.0;
			picked = true;
		elif !picked and Type in GameInfo.resources and ((GameInfo.resources[self.Type] > 0 and get_parent().spawnedIngredients[self.Type] < GameInfo.resources[self.Type]) or GameInfo.resources[self.Type] < 0):
			# Make sure we have enough energy to brew a potion, so that ingredients aren't wasted.
			if GameInfo.energy > GameInfo.minigameEnergy[1]:
				var copy = self.duplicate()
				copy.movable = true;
				copy.mouseOffset = Vector2.ZERO;
				copy.freeze = false;
				copy.beingMoved = true;
				copy.set_collision_layer_value(2, true);
				copy.set_collision_layer_value(1, false);
				copy.set_collision_mask_value(1, false);
				copy.set_collision_mask_value(2, true);
				get_parent().add_child(copy);
				get_parent().spawnedIngredients[self.Type] += 1;
				
				if copy.get_child(2).get_child_count() > 0:
					copy.get_child(2).get_child(0).queue_free();
			else:
				NotEnoughEnergyForBrewing.emit();

func released():
	if beingMoved:
		picked = false;
		beingMoved = false;
		self.gravity_scale = 1.0;

func _on_start_stirring():
	if movable:
		queue_free();
	else:
		self.freeze = true;

func _on_mouse_entered() -> void:
	mouseOver = true;

func _on_mouse_exited() -> void:
	mouseOver = false;
