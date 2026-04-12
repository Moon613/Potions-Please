@tool
extends Area2D
@export var SceneID: int;
@export var Size: Vector2 = Vector2(20,20):
	set(value):
		Size = value;
		$CollisionShape2D.shape.size = value;
@export var DialogueChoice: String;
signal InteractedWith(id: int);

var interactionCooldown = 240;

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		InteractedWith.connect(get_tree().current_scene._switch_scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Engine.is_editor_hint():
		if interactionCooldown > 0:
			interactionCooldown -= 1;
		var player: Node2D = get_parent().get_children().filter(func(obj: Node2D): return obj.is_in_group("Player"))[0];
		var distance = (self.position - player.position).length();
		$AnimatedSprite2D.modulate.a = lerp(1, 0, (distance-15)/30);
		$Sprite2D.modulate.a = lerp(1, 0, (distance-15)/30);
	

func _input(event):
	if event is InputEvent and event.is_action_pressed("ui_accept") and !DialogueManager.inDialogue:
		var playerIndex = get_overlapping_bodies().find_custom(func(obj: Node2D): return obj.is_in_group("Player"));
		if playerIndex != -1:
			DialogueManager.TriggerDialogue(DialogueChoice);
			get_viewport().set_input_as_handled();
