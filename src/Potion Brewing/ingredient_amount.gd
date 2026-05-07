extends RichTextLabel

@export var Type: String;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var amount = GameInfo.resources[Type];
	text = str(get_parent().spawnedIngredients[Type]) + "/" + str(amount);
	if amount == -1:
		text = "∞";
