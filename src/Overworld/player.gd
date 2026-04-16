extends CharacterBody2D;


@export var SPEED = 40.0;
@export var collidedWithTransition = false;
@export var canTriggerSceneTransitions = false;

var timer: float = 0.0;
var movementTutorialAppear: bool = false;

func _ready() -> void:
	DialogueManager.startMovementTutorial.connect(_on_movement_tutorial_start);

func _process(delta: float) -> void:
	if GameInfo.leftHouseForFirstTime and !GameInfo.finishedGatheringTutorial:
		var closestTrigger: Node2D = null;
		for trigger in get_parent().get_children().filter(func(child): return child.is_in_group("Interactable trigger")):
			if closestTrigger == null or (self.position-trigger.position).length() < (self.position-closestTrigger.position).length():
				closestTrigger = trigger;
		if closestTrigger != null:
			$DirectionArrow.modulate.a = lerp(0, 1, ((self.position-closestTrigger.position).length()-10)/10);
			$DirectionArrow.look_at(closestTrigger.position)
	else:
		$DirectionArrow.self_modulate.a = 0;
	
	if timer < 1 and movementTutorialAppear:
		timer += delta;
	if timer > 0 and !movementTutorialAppear:
		timer -= delta;
		
	if timer > 1:
		timer = 1;
	if timer < 0:
		timer = 0;
	
	$MovementTutorialUI.modulate.a = timer;
	
	var leftRight = Input.get_axis("ui_left", "ui_right") * float(movementTutorialAppear);
	var upDown = Input.get_axis("ui_up", "ui_down") * float(movementTutorialAppear);
	if leftRight < 0:
		GameInfo.directionTutorial["a"] = true;
		$MovementTutorialUI/A.frame = 1;
	if leftRight > 0:
		GameInfo.directionTutorial["d"] = true;
		$MovementTutorialUI/D.frame = 1;
	if upDown < 0:
		GameInfo.directionTutorial["w"] = true;
		$MovementTutorialUI/W.frame = 1;
	if upDown > 0:
		GameInfo.directionTutorial["s"] = true;
		$MovementTutorialUI/S.frame = 1;
	if GameInfo.directionTutorial["a"] and GameInfo.directionTutorial["d"] and GameInfo.directionTutorial["w"] and GameInfo.directionTutorial["s"]:
		movementTutorialAppear = false;
		GameInfo.doneMovementTutorial = true;

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var sprinting = 2 if Input.is_key_pressed(KEY_CTRL) else 1;
	var vertDir = Input.get_axis("ui_left", "ui_right") * float(!DialogueManager.inDialogue);
	var horDir = Input.get_axis("ui_up", "ui_down") * float(!DialogueManager.inDialogue);
	if vertDir:
		velocity.x = vertDir * SPEED * sprinting;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED);
	if horDir:
		velocity.y = horDir * SPEED * sprinting;
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED);
	
	if velocity.x < 0:
		$AnimatedSprite2D.frame = 2;
	elif velocity.x > 0:
		$AnimatedSprite2D.frame = 3;
	elif velocity.y < 0:
		$AnimatedSprite2D.frame = 0;
	elif velocity.y > 0:
		$AnimatedSprite2D.frame = 1;
	if collidedWithTransition:
		if canTriggerSceneTransitions:
			var transitionIndex = $"Transition Buffer".get_overlapping_areas().find_custom(func(obj: Node2D): return obj is Area2D and obj.name == "Loading Zone");
			if transitionIndex == -1:
				collidedWithTransition = false;
				canTriggerSceneTransitions = false;
		else:
			canTriggerSceneTransitions = true;

	move_and_slide();

func _on_movement_tutorial_start():
	movementTutorialAppear = true;

func _on_loading_zone_reject():
	$MovementTutorialUI._on_loadingzone_reject();
