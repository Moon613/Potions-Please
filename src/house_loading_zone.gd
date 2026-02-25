extends Area2D
signal switch_scene(id: int);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_tree().current_scene)
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		switch_scene.connect(get_tree().current_scene._switch_scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Lambda function here for checking if the area has collided with a player.
	if get_overlapping_bodies().any(func(obj): return obj is CharacterBody2D):
		print("Collided with player")
		switch_scene.emit(2);
	pass
