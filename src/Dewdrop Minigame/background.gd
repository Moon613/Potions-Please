extends Sprite2D

var blurring = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var currentBlur = self.material.get_shader_parameter("blur_amount");
	if self.material is ShaderMaterial and currentBlur < 5:
		self.material.set_shader_parameter("blur_amount", currentBlur + 1);
		print(currentBlur)


func _on_minigame_transition_to_drying():
	blurring = true;
