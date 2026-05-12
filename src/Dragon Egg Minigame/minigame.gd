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

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.warp_mouse(get_viewport_rect().size * 0.5);
	_maxTimeSeconds = 60 * maxMinutes;
	_eggAmount = clamp(eggAmount, 1, DragonEgg.hidingSpots.size()-1);
	ChangeIngredients.connect(GameInfo._change_ingredient_amount);
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);
	print("adding eggs")
	for i in _eggAmount:
		print("instantiating egg")
		var egg: DragonEgg = dragonEggScene.instantiate();
		print("tracking egg")
		egg.name = "Egg" + str(i);
		print("add egg to group")
		egg.add_to_group("Dragon Egg");
		print("connecting to egg")
		egg.eggObtained.connect(self._on_egg_obtained);
		print("adding egg to children")
		add_child(egg);
	print("Scene is readied")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameInfo.dragoneggTutorial:
		$Tutorial.popup();
		$Tutorial.move_to_center();
	if !GameInfo.dragoneggTutorial:
		$Tutorial.hide()
		$ColorRect.material.set_shader_parameter("mousePos", get_global_mouse_position() / -(get_viewport_rect().size / $Camera2D.zoom));
		timer += delta;
	if timer >= _maxTimeSeconds or eggsObtained == _eggAmount:
		ChangeIngredients.emit(GameInfo.EGGS, eggsObtained);
		Input.set_custom_mouse_cursor(load("res://Textures/SuperiorCursor.png"), 0, Vector2.ZERO);
		ReturnToOverworld.emit(0);
		GameInfo.finishedGatheringTutorial = true;
		GameInfo.energy -= GameInfo.minigameEnergy[GameInfo.SceneID.DRAGONEGGS];
		self.queue_free()
	
	$ColorRect/RichTextLabel.text = "%01d:%02d" % [max(_maxTimeSeconds/60-1, 0) - int(timer)/60, (maxMinutes-floori(maxMinutes))*60-int(timer)%60];
	pass

#func Reset():
	#timer = 0;
	#eggsObtained = 0;
	#for child in get_children().filter(func(c:Node2D): c.is_in_group("Dragon Egg")):
		#child.queue_free();

func _input(event):
	if event.is_action_pressed("ui_cancel") and GameInfo.busy:
		get_viewport().set_input_as_handled()
		Input.set_custom_mouse_cursor(load("res://Textures/SuperiorCursor.png"), 0, Vector2.ZERO);
		ReturnToOverworld.emit(0);
		GameInfo.finishedGatheringTutorial = true;
		self.queue_free()

func _on_egg_obtained():
	eggsObtained += 1;
	$CollectionSound.play();

func _on_tutorial_popup_hide() -> void:
	GameInfo.dragoneggTutorial = false
	Input.set_custom_mouse_cursor(load("res://Dragon Egg Minigame/Textures/TargetCursor.png"), 0, Vector2(26,33));
	get_tree().paused = false

func _on_info_button_pressed() -> void:
	GameInfo.dragoneggTutorial = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Tutorial.popup();
	$Tutorial.move_to_center();
