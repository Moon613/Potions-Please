@tool
class_name Boundary
extends Area2D
@export var DialogueChoice: String;
@export var GameinfoFlag: String;
@export var ReflectDirection: Vector2i:
	set(value):
		ReflectDirection = value.clamp(Vector2i(-1, -1), Vector2i(1, 1));

var player: Player = null;
var timer: float = 0;
var movePlayer: bool = false;
const TIME: float = 0.25;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Engine.is_editor_hint():
		if movePlayer and timer < TIME:
			timer += delta;
			# Clear inputs
			ClearInput();
			# Re-set them to what we want
			if ReflectDirection.x < 0:
				Input.action_press("ui_left");
			elif ReflectDirection.x > 0:
				Input.action_press("ui_right");
			if ReflectDirection.y < 0:
				Input.action_press("ui_up");
			elif ReflectDirection.y > 0:
				Input.action_press("ui_down");
			
			player._physics_process(delta);
		elif timer >= TIME:
			timer = 0;
			ClearInput();
			player.set_physics_process(true);
			player = null;
			movePlayer = false;

func _on_body_entered(body: Node2D) -> void:
	if !Engine.is_editor_hint() and body.is_in_group("Player") and GameinfoFlag in GameInfo and !GameInfo.get(GameinfoFlag):
		ClearInput();
		player = body;
		player.set_physics_process(false);
		DialogueManager.TriggerDialogue(DialogueChoice);
		DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(func():
			movePlayer = true;
		));

func ClearInput():
	Input.action_release("ui_right");
	Input.action_release("ui_left");
	Input.action_release("ui_down");
	Input.action_release("ui_up");
