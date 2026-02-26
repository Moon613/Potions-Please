@tool
extends Area2D
@export var SceneID: int;
@export var Size: Vector2 = Vector2(20,20):
	set(value):
		Size = value;
		$CollisionShape2D.shape.size = value;
signal switch_scene(id: int);

var previouslyOverlapped = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		switch_scene.connect(get_tree().current_scene._switch_scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Lambda function here for checking if the area has collided with a player.
	if get_overlapping_bodies().any(func(obj): return obj is CharacterBody2D):
		print("Collided with player")
		switch_scene.emit(SceneID);
	pass
