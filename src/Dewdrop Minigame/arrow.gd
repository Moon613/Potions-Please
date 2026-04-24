extends Area2D

signal Success;
signal Faliure;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	var parent: DewdropMinigame = get_parent();
	if parent.startDrying and event is InputEventKey and event.keycode == KEY_SPACE and !event.echo and event.pressed:
		var overlappingBodies: Array[Node2D] = get_overlapping_bodies().filter(func(child: Node2D): return child.is_in_group("Green Bar"));
		if !overlappingBodies.is_empty():
			Success.emit();
		else:
			Faliure.emit();
