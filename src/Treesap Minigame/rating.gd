extends AnimatedSprite2D

var startingPos: Vector2;
var appearing: bool = true;
var waiting: bool = false;
var timer: float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = self.position;
	#TweenRotate(0.1, 0.05);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if appearing:
		timer += delta;
		self.scale *= 1.05;
		if timer >= 0.2:
			appearing = false;
			waiting = true;
			self.timer = 0;
	if waiting:
		self.timer += delta;
		if self.timer >= 0.5:
			self.rotation = 0;
			self.timer = 0.2;
			self.waiting = false;
	if !appearing and !waiting:
		self.scale *= 0.75;
		self.timer -= delta;
	self.position.y -= 0.5;
	if self.timer <= 0:
		self.queue_free();


func SetSprite(id: int):
	self.frame = id;


func TweenRotate(endRotation: float, speed: float):
	var tween = get_tree().create_tween();
	tween.tween_property(self, "rotation", endRotation, speed);
	tween.tween_property(self, "rotation", endRotation*-1.0, speed);
	tween.tween_property(self, "rotation", endRotation, speed);
	tween.tween_property(self, "rotation", endRotation*-1.0, speed);
	tween.tween_property(self, "rotation", endRotation, speed);
	tween.tween_property(self, "rotation", endRotation*-1.0, speed);
	tween.tween_property(self, "rotation", endRotation, speed);
	tween.tween_property(self, "rotation", endRotation*-1.0, speed);
	tween.tween_property(self, "rotation", endRotation, speed);
	tween.tween_property(self, "rotation", endRotation*-1.0, speed);
	tween.tween_property(self, "rotation", endRotation, speed);
	tween.tween_property(self, "rotation", endRotation*-1.0, speed);
	tween.tween_property(self, "rotation", endRotation, speed);
