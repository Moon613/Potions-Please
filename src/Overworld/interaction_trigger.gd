@tool
extends Area2D
@export var SceneID: int;
@export var Size: Vector2 = Vector2(20,20):
	set(value):
		Size = value;
		$CollisionShape2D.shape.size = value;
signal InteractedWith(id: int);
signal PlayerThoughts(message: String);

var interactionCooldown: float = 3;
const COOLDOWN_TIME: float = 2;

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		InteractedWith.connect(get_tree().current_scene._switch_scene)
	if !Engine.is_editor_hint():
		$EnergyCost.text = str(GameInfo.minigameEnergy[SceneID]);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Running this code while in the editor causes 1 morbillion bugs, so don't :)
	if !Engine.is_editor_hint():
		if interactionCooldown > 0:
			interactionCooldown -= delta;
		var player: Node2D = get_parent().get_children().filter(func(obj: Node): return obj.is_in_group("Player"))[0];
		var distance = (self.position - player.position).length();
		$AnimatedSprite2D.self_modulate.a = lerp(1, 0, (distance-15)/30);
		$Sprite2D.self_modulate.a = lerp(1, 0, (distance-15)/30);
		$EnergyCost.self_modulate.a = lerp(1, 0, (distance-15)/30);
		$EnergySprite.self_modulate.a = lerp(1, 0, (distance-15)/30);
	

func _input(event):
	if event is InputEvent and event.is_action_pressed("ui_accept"):
		var playerIndex = get_overlapping_bodies().find_custom(func(obj: Node2D): return obj.is_in_group("Player"));
		if playerIndex != -1 and interactionCooldown <= 0:
			if SceneID != GameInfo.SceneID.DEWDROPS and GameInfo.leftHouseForFirstTime and !GameInfo.finishedGatheringTutorial:
				interactionCooldown = COOLDOWN_TIME;
				DialogueManager.TriggerDialogue("GatherDewdropsFirst")
				get_viewport().set_input_as_handled();
			elif SceneID == GameInfo.SceneID.DEWDROPS and (!GameInfo.reenterPotionBrewingScreen and GameInfo.minigameExit):
				pass
			elif SceneID in GameInfo.minigameEnergy and GameInfo.minigameEnergy[SceneID] < GameInfo.energy:
				interactionCooldown = COOLDOWN_TIME;
				InteractedWith.emit(SceneID);
			else:
				$AnimationPlayer.play("Energy Shake");
				PlayerThoughts.emit("I don't have enough energy...");
