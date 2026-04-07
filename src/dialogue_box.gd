class_name DialogueBox
extends Sprite2D

var timer: float = 0;
var appearing: bool = true;
const startPos: Vector2 = Vector2(0, 430);
const endPos: Vector2 = Vector2(0, 220)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if appearing and timer < 1:
		self.position = startPos.lerp(endPos, timer);
		timer += delta * 3;
	if !appearing and timer > 0:
		self.position = startPos.lerp(endPos, timer);
		timer -= delta * 3;
	if !appearing and timer <= 0:
		queue_free();

func _input(event):
	if event is InputEvent and event.is_action_pressed("ui_accept"):
		appearing = false;
		timer = 1;

func SetText(text: String):
	$RichTextLabel.text = text;

func SetPortrait(portrait: Texture2D):
	$Portrait.texture = portrait;
