@tool
extends Area2D
@export var SceneID: int;
@export var Size: Vector2 = Vector2(20,20):
	set(value):
		Size = value;
		$CollisionShape2D.shape.size = value;
signal InteractedWith(id: int);

var interactionCooldown = 240;

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		InteractedWith.connect(get_tree().current_scene._switch_scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if interactionCooldown > 0:
		interactionCooldown -= 1;
	pass

func _input(event):
	if event is InputEvent and event.is_action_pressed("ui_accept"):
		var playerIndex = get_overlapping_bodies().find_custom(func(obj: Node2D): return obj is CharacterBody2D and obj.name == "Player");
		if playerIndex != -1:
			interactionCooldown = 240
			InteractedWith.emit(SceneID);
