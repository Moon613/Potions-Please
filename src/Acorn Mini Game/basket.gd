extends CharacterBody2D

@export var speed = 400.0

func _physics_process(_delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, -screen_size.x/2, screen_size.x/2)

func collect():
	$"..".acornsCollected += 1
