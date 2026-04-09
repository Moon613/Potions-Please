extends Node2D

signal ReturnToOverworld(id: int);
signal ChangeIngredients(ingr: String, amt: int);

@export var maxMinutes: float = 2;
@export var eggAmount: int = 0;
var _maxTimeSeconds: int;
var _eggAmount: int;
var dragonEggScene: PackedScene = preload("res://Dragon Egg Minigame/Dragon Egg.tscn");
var timer: float = 0;
var eggsObtained: int = 0;
var triggeredPopup: bool = false;
var closedPopup: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.warp_mouse(get_viewport_rect().size * 0.5);
	_maxTimeSeconds = 60 * maxMinutes;
	_eggAmount = clamp(eggAmount, 1, DragonEgg.hidingSpots.size()-1);
	ChangeIngredients.connect(GameInfo._change_ingredient_amount);
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);
	for i in _eggAmount:
		var egg: DragonEgg = dragonEggScene.instantiate();
		egg.name = "Egg" + str(i);
		egg.add_to_group("Dragon Egg");
		egg.eggObtained.connect(self._on_egg_obtained);
		add_child(egg);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !triggeredPopup:
		$Tutorial.popup();
		$Tutorial.move_to_center();
		triggeredPopup = true;
		closedPopup = false;
	if closedPopup:
		$ColorRect.material.set_shader_parameter("mousePos", get_global_mouse_position() / -(get_viewport_rect().size / $Camera2D.zoom));
		timer += delta;
	if timer >= _maxTimeSeconds or eggsObtained == _eggAmount:
		ChangeIngredients.emit(GameInfo.EGGS, eggsObtained);
		Reset();
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		ReturnToOverworld.emit(0);
	
	$ColorRect/RichTextLabel.text = "%01d:%02d" % [max(_maxTimeSeconds/60-1, 0) - int(timer)/60, (maxMinutes-floori(maxMinutes))*60-int(timer)%60];
	pass

func Reset():
	timer = 0;
	eggsObtained = 0;
	for child in get_children().filter(func(c:Node2D): c.is_in_group("Dragon Egg")):
		child.queue_free();

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		ReturnToOverworld.emit(0);

func _on_egg_obtained():
	eggsObtained += 1;

func _on_tutorial_popup_hide() -> void:
	closedPopup = true;
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
