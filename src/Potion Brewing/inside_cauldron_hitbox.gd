extends Area2D

signal StartStirring;
signal ConsumeIngredient(type: String);
signal WaterlogSpoonToggle;
var startedStirring: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bodies = get_overlapping_bodies();
	for body in bodies:
		if body.is_in_group("Draggable Ingredients"):
			BrewingIngredient.picked = false;
			body.queue_free();
			# This is a little bit lazy, but we know that the signal will always exist so it's harmless
			ConsumeIngredient.emit(body.Type);
		if body.is_in_group("Spoon") and !startedStirring:
			print("Started Stirring")
			StartStirring.emit();
			startedStirring = true;


func _on_body_entered(body: Node2D):
	if body.is_in_group("Spoon"):
		WaterlogSpoonToggle.emit();

func _on_body_exited(body: Node2D):
	if body.is_in_group("Spoon"):
		WaterlogSpoonToggle.emit();
