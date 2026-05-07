class_name BrewingProgress
extends ProgressBar

var target: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = value + (target-value)*0.1;
	if abs(target-value) <= 0.05:
		value = round(value);


func IncreaseTargetValue():
	target += 1;

func _on_potion_disappeared():
	target = 0;
