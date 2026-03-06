extends Node2D
signal TransitionToDrying;
signal ReturnToOverworld(id: int);
signal RemoveJar;
signal DewCollected(drops_collected: int)

@export var dewdrop: PackedScene = preload("res://Dewdrop Minigame/dewdrop.tscn")
@export var number_of_dewdrops: int
var numberOfDropsCollected = 0;
var removedJar: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene)
	for n:int in abs(number_of_dewdrops):
		var dewdropInstance = dewdrop.instantiate();
		dewdropInstance.position = Vector2(randi_range(-900, 900), randi_range(-500, 360));
		dewdropInstance.name = "Dewdrop" + str(n);
		dewdropInstance.get_node("AnimatedSprite2D").frame = randi_range(0, 3);
		add_child(dewdropInstance);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for child in get_children():
		if child is RigidBody2D and child.position.y > 380:
			remove_child(child);
	if get_children().size() == 4 and $Rag.farthestStretch >= 1.8 and !removedJar:
		$"Collection Jar".frame = 1;
		RemoveJar.emit();
		removedJar = true;

func _on_rag_collected_drop():
	numberOfDropsCollected += 1;
	if numberOfDropsCollected >= number_of_dewdrops:
		TransitionToDrying.emit();

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ReturnToOverworld.emit(0);


func _on_collection_jar_done_move_down():
	ReturnToOverworld.emit(0);
