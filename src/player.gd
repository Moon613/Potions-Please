extends CharacterBody2D;


const SPEED = 40.0;
var collidedWithTransition = false;
var canTriggerSceneTransitions = false;


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var sprinting = 2 if Input.is_key_pressed(KEY_CTRL) else 1;
	var vertDir = Input.get_axis("ui_left", "ui_right");
	var horDir = Input.get_axis("ui_up", "ui_down");
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
			print($"Transition Buffer".get_overlapping_areas())
			var transitionIndex = $"Transition Buffer".get_overlapping_areas().find_custom(func(obj: Node2D): return obj is Area2D and obj.name == "Loading Zone");
			print(transitionIndex)
			if transitionIndex == -1:
				collidedWithTransition = false;
				canTriggerSceneTransitions = false;
		else:
			canTriggerSceneTransitions = true;

	move_and_slide();
