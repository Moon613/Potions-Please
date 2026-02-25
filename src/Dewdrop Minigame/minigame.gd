extends Node2D
signal TransitionToDrying;

@export var dewdrop: PackedScene = preload("res://Dewdrop Minigame/dewdrop.tscn")
@export var number_of_dewdrops: int
var numberOfDropsCollected = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	for n:int in abs(number_of_dewdrops):
		var dewdropInstance = dewdrop.instantiate();
		dewdropInstance.position = Vector2(randi_range(-900, 900), randi_range(-500, 360));
		dewdropInstance.name = "Dewdrop" + str(n);
		dewdropInstance.get_node("AnimatedSprite2D").frame = randi_range(0, 3);
		add_child(dewdropInstance);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_rag_collected_drop():
	numberOfDropsCollected += 1;
	if numberOfDropsCollected >= number_of_dewdrops:
		TransitionToDrying.emit();
