@tool
extends Area2D
@export var DialogueChoice: String;
@export var GameinfoFlag: String;
@export var Size: Vector2 = Vector2(20,20):
	set(value):
		Size = value;
		$CollisionShape2D.shape.size = value;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Running this code while in the editor causes 1 morbillion bugs, so don't :)
	pass
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and GameinfoFlag in GameInfo and !GameInfo.get(GameinfoFlag):
		GameInfo.set(GameinfoFlag, true);
		DialogueManager.TriggerDialogue(DialogueChoice);
