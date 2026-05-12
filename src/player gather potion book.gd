extends Node

var player: Player;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0];
	player.set_physics_process(false);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.position.x < -25:
		Input.action_release("ui_left");
		Input.action_release("ui_up");
		Input.action_release("ui_down");
		Input.action_press("ui_right");
	elif player.position.y > 7:
		Input.action_release("ui_left");
		Input.action_release("ui_right");
		Input.action_release("ui_down");
		Input.action_press("ui_up");
	else:
		Input.action_release("ui_left");
		Input.action_release("ui_right");
		Input.action_release("ui_down");
		Input.action_release("ui_up");
		player.set_physics_process(true);
		get_viewport().warp_mouse(get_viewport().get_visible_rect().size/2 + Vector2(-200, -30));
		DialogueManager.GrabPotionBook();
		queue_free();
		return;
	player._physics_process(delta);
