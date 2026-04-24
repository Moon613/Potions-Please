extends Node2D
class_name DewdropMinigame
signal TransitionToDrying;
signal ReturnToOverworld(id: int);
signal ChangeIngredients(ingr: String, amt: int);
signal RemoveJar;
signal MouseReleased;

@export var dewdrop: PackedScene = preload("res://Dewdrop Minigame/dewdrop.tscn")
@export var number_of_dewdrops: int
@onready var tutorial: Popup = $Tutorial
var numberOfDropsCollected = 0;
var removedJar: bool = false;
var dropsCollected = 0;
var doneUIFadeIn: bool = false;
var startDrying: bool = false;
var timingSuccesses: int = 0;
var timingFailures: int = 0;
var maximumSliderAttempts: int = 0;
var canEndMinigame: bool = false;
const SLIDER_SHRINK_AMOUNT: int = 250;

# Called when the node enters the scene tree for the first time.
func _ready():
	if !GameInfo.dewdropTutorial:
		tutorial.hide()
	ChangeIngredients.connect(GameInfo._change_ingredient_amount);
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);
		
	for n:int in abs(number_of_dewdrops):
		var dewdropInstance = dewdrop.instantiate();
		dewdropInstance.position = Vector2(randi_range(-900, 900), randi_range(-500, 360));
		dewdropInstance.name = "Dewdrop" + str(n);
		dewdropInstance.get_node("AnimatedSprite2D").frame = randi_range(0, 3);
		add_child(dewdropInstance);
	
	$"Control/Slider Background".self_modulate.a = 0;
	$"Control/Slider Good Area".self_modulate.a = 0;
	$Arrow.modulate.a = 0;
	$Control/ReadyText.visible = false;
	$"Space Button".visible = false;
	$Control/Greyout.visible = false;
	maximumSliderAttempts = $"Green Bar Detection/CollisionShape2D".shape.size.x / SLIDER_SHRINK_AMOUNT;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var array = get_children().filter(func(child): return child.is_in_group("Dewdrop"))
	if canEndMinigame and array.is_empty() and !removedJar:
		RemoveJar.emit();
		removedJar = true;

func _on_rag_collected_drop():
	numberOfDropsCollected += 1;
	$CollectionNoise.play()
	if numberOfDropsCollected >= number_of_dewdrops:
		TransitionToDrying.emit();

func _input(event):
	if event as InputEventMouseButton and event.button_index == 1 and !event.pressed:
		MouseReleased.emit();
	if event.is_action_pressed("ui_cancel") and GameInfo.busy:
		get_viewport().set_input_as_handled()
		ReturnToOverworld.emit(0);
		GameInfo.finishedGatheringTutorial = true;
		self.queue_free()
	if !startDrying and doneUIFadeIn and event is InputEventKey and event.keycode == KEY_SPACE:
		$AnimationPlayer.play("Arrow Move");
		$Control/Greyout.visible = false;
		$Control/ReadyText.visible = false;
		$"Space Button".visible = false;
		startDrying = true;

func _on_collection_jar_done_move_down():
	ChangeIngredients.emit("dewdrops", timingSuccesses);
	ReturnToOverworld.emit(0);
	GameInfo.finishedGatheringTutorial = true;
	GameInfo.energy -= GameInfo.minigameEnergy[GameInfo.SceneID.DEWDROPS];
	self.queue_free()

func _on_tutorial_popup_hide() -> void:
	GameInfo.dewdropTutorial = false
	get_tree().paused = false

func _on_info_button_pressed() -> void:
	GameInfo.dragoneggTutorial = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Control/Tutorial.popup();
	$Control/Tutorial.move_to_center();

func _on_rag_reappearing():
	$AnimationPlayer.play("UI Fade In");

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "UI Fade In":
		doneUIFadeIn = true;

func _on_arrow_success():
	timingSuccesses += 1;
	ShrinkSliderArea();

func _on_arrow_faliure():
	timingFailures += 1;
	ShrinkSliderArea();

func ShrinkSliderArea():
	$"Control/Slider Good Area".size.x -= SLIDER_SHRINK_AMOUNT;
	$"Control/Slider Good Area".position.x += SLIDER_SHRINK_AMOUNT*0.5;
	$"Green Bar Detection/CollisionShape2D".shape.size.x -= SLIDER_SHRINK_AMOUNT;
	$AnimationPlayer.speed_scale *= 1.25;
	if timingSuccesses + timingFailures >= maximumSliderAttempts:
		$"Collection Jar/AnimatedSprite2D".frame = 1;
		$AnimationPlayer.stop(true);
		canEndMinigame = true;

func _on_collection_jar_collected_drop():
	dropsCollected += 1
