extends Node2D
signal ReturnToOverworld(id: int);
signal ChangeIngredients(ingr: String, amt: int);
signal ShowIngredient;



@export var mandrake_fake: PackedScene = preload("res://Mandrake Minigame/fakeMandrakes.tscn")
@export var mandrake_real: PackedScene = preload("res://Mandrake Minigame/mandrake.tscn")
@onready var hammer: Area2D = $Hammer
@onready var hammer_anim: AnimatedSprite2D = $Hammer/HammerAnimation
@onready var hammer_hitbox: CollisionShape2D = $Hammer/HammerHitbox
@onready var hammer_hit: Timer = $HammerHit
@onready var hammer_cooldown: Timer = $HammerCooldown


@export var number_of_mandrakes: int
@export var number_of_fakes: int
var mandrakesEscaped: int = 0;
var mandrakesCollected: int = 0;
var gameStart: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.warp_mouse(get_viewport_rect().size * 0.5);
	ChangeIngredients.connect(GameInfo._change_ingredient_amount);
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene);
		
	for n:int in abs(number_of_mandrakes):
		var mandrakeInstance = mandrake_real.instantiate();
		mandrakeInstance.position = Vector2(randi_range(-900, 900), randi_range(-500, 360));
		mandrakeInstance.name = "Mandrake" + str(n);
		add_child(mandrakeInstance);
		
	for n:int in abs(number_of_fakes):
		var fakeInstance = mandrake_fake.instantiate();
		fakeInstance.position = Vector2(randi_range(-900, 900), randi_range(-500, 360));
		fakeInstance.name = "Shrubs" + str(n);
		add_child(fakeInstance);
	
	hammer_anim.play("default")
	hammer_hitbox.disabled = true
	hammer.visible = false
	if GameInfo.mandrakeTutorial:
		$Tutorial.popup();
		$Tutorial.move_to_center();
	else:
		$Tutorial.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !GameInfo.mandrakeTutorial && !gameStart:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		for child in get_children():
			if child.is_in_group("Mandrakes"):
				child.activation_timer.start()
		hammer.visible = true
		gameStart = true
	hammer.position = get_global_mouse_position()
	for child in get_children():
		if child.is_in_group("Mandrakes"):
			if child.position.x > 1000 or child.position.x < -1000:
				remove_child(child)
				mandrakesEscaped += 1
	
	if (mandrakesCollected + mandrakesEscaped) >= number_of_mandrakes:
		ShowIngredient.emit()


func _input(event):
	if event.is_action_pressed("ui_cancel") and GameInfo.busy:
		get_viewport().set_input_as_handled()
		minigame_end()
	if event is InputEventMouseButton and event.is_pressed():
		hammer_anim.play("whack")
		hammer_hitbox.disabled = false
		hammer_hit.start()
		print("pow")
	pass

func minigame_end():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ChangeIngredients.emit("mandrake", mandrakesCollected);
	ReturnToOverworld.emit(0);
	GameInfo.energy -= GameInfo.minigameEnergy[GameInfo.SceneID.MANDRAKES];
	self.queue_free()


func _on_hammer_area_entered(area: Area2D) -> void:
	if area.is_in_group("Mandrakes") and not hammer_hitbox.disabled:
		if not area.mandrake_hurtbox.disabled:
			print("gotcha")
			$CollectionNoise.play()
			mandrakesCollected += 1
			area.mandrake_hurtbox.disabled = true
		pass


func _on_hammer_hit_timeout() -> void:
	hammer_hitbox.disabled = true
	pass # Replace with function body.


func _on_tutorial_popup_hide() -> void:
	GameInfo.mandrakeTutorial = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	pass # Replace with function body.


func _on_mandrake_ingredient_ingredient_done_showing() -> void:
	print("Movie done")
	minigame_end()
	pass # Replace with function body.


func _on_info_button_pressed() -> void:
	GameInfo.mandrakeTutorial = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Tutorial.popup();
	$Tutorial.move_to_center();
	pass # Replace with function body.
