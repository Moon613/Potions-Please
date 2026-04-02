extends Node2D

signal ReturnToOverworld(id: int);
signal ChangeIngredients(ingr: String, amt: int);

@export var maxTime: int = 500;
var timer: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	ChangeIngredients.connect(GameInfo._change_ingredient_amount);
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ColorRect.material.set_shader_parameter("mousePos", get_global_mouse_position() / -(get_viewport_rect().size / $Camera2D.zoom));
	if timer >= maxTime:
		pass
	
	timer += delta;
	$RichTextLabel.text = "%01d:%02d" % [(maxTime)/60-1 - int(timer)/60, 59-int(timer)%60];
	pass

func Reset():
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		ReturnToOverworld.emit(0);
