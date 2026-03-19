extends Area2D

signal StartStirring;
var startedStirring: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bodies = get_overlapping_bodies();
	for body in bodies:
		if body.is_in_group("Draggable Ingredients"):
			body.queue_free();
			# This is a little bit lazy, but we know that the signal will always exist so it's harmless
			get_parent().ChangeIngredients.emit(body.Type, -1);
		if body.is_in_group("Spoon") and !startedStirring:
			StartStirring.emit();
			startedStirring = true;
