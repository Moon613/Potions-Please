extends PointLight2D

@export var timer: float = 0;
@export var refreshTime: float = 0.2;
var image: ImageTexture;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta;
	if timer >= refreshTime:
		var tex: ViewportTexture = %SunspotsViewport.get_texture();
		image = ImageTexture.create_from_image(tex.get_image());
		self.texture = image;
		timer = 0;
