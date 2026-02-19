extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var sprint = 2 if Input.is_physical_key_pressed(KEY_SHIFT) else 1;
	if (Input.is_physical_key_pressed(KEY_W)):
		self.position.y -= sprint*20*delta;
	elif (Input.is_physical_key_pressed(KEY_S)):
		self.position.y += sprint*20*delta;
	if (Input.is_physical_key_pressed(KEY_A)):
		self.position.x -= sprint*20*delta;
	elif (Input.is_physical_key_pressed(KEY_D)):
		self.position.x += sprint*20*delta;
	pass
