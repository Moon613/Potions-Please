extends Area2D

@export var number: int = 0;

signal SpoonEnteredArea(num: int);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_shape_entered.connect(_on_body_shape_entered);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int):
	if body.shape_owner_get_owner(body.shape_find_owner(body_shape_index)).is_in_group("Spoon Stir Hitbox"):
		SpoonEnteredArea.emit(number);
