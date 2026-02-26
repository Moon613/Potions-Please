extends Sprite2D

var blurring = false;
const BLUR_AMOUNT = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if blurring:
		var currentBlur = self.material.get_shader_parameter("blur_amount");
		if self.material is ShaderMaterial and currentBlur < 5:
			self.material.set_shader_parameter("blur_amount", currentBlur + BLUR_AMOUNT*delta);
			self.scale -= Vector2(0.2, 0.2) * delta;
			self.position.y -= 180 * delta;
		elif currentBlur >= 5:
			blurring = false;


func _on_minigame_transition_to_drying():
	blurring = true;
