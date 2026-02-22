extends CharacterBody2D;


const SPEED = 40.0;


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

	move_and_slide();
