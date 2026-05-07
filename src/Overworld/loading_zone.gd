@tool
extends Area2D
@export var SceneID: int;
@export var Size: Vector2 = Vector2(20,20):
	set(value):
		Size = value;
		$CollisionShape2D.shape.size = value;
var rejectedPlayer: bool = false;
signal switch_scene(id: int);
signal reject();

var previouslyOverlapped = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		switch_scene.connect(get_tree().current_scene._switch_scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return;
	# Lambda function here for checking if the area has collided with a player.
	var playerIndex = get_overlapping_bodies().find_custom(func(obj: Node2D): return obj.is_in_group("Player"));
	if playerIndex != -1:
		# This is an early exit that prevents changing scenes if the player has not done the movement tutorial
		# It also locks itself untill the player moves out of the hitbox again, to prevent abrupt scene changing
		if SceneID != GameInfo.SceneID.INSIDEHOUSE and SceneID != GameInfo.SceneID.UPSTAIRS and (!GameInfo.doneMovementTutorial or !GameInfo.seenPotionBrewingScreen or (GameInfo.leftHouseForFirstTime and !GameInfo.finishedGatheringTutorial) or rejectedPlayer):
			if !rejectedPlayer:
				reject.emit();
				DialogueManager.AddDialogue(DialogueManager.DialogueText.new("I should probably brew a potion before doing anything too strenuous...", DialogueManager.Dialogue.YASMEEN));
				rejectedPlayer = true;
			return;
		var player = get_overlapping_bodies()[playerIndex];
		if !player.collidedWithTransition:
			player.collidedWithTransition = true;
			# This is only here temporarily until I need to actually move it where it makes sense
			switch_scene.emit(SceneID);
	else:
		rejectedPlayer = false;
