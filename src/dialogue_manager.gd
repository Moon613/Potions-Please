extends CanvasLayer

var inDialogue: bool = false;
var dialogueQueue: Array[Dialogue] = [];
var dialogueBox: PackedScene = preload("res://Dialogue Box.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEvent and event.is_action_pressed("ui_accept") and inDialogue:
		PlayNextDialogue();

func AddDialogue(dialogue: Dialogue):
	dialogueQueue.append(dialogue);
	if !inDialogue:
		inDialogue = true;
		PlayNextDialogue();

func PlayNextDialogue():
	if dialogueQueue.is_empty():
		inDialogue = false;
		return;
	var nextDialogue: Dialogue = dialogueQueue.pop_front();
	if nextDialogue is DialogueText:
		var box: DialogueBox = dialogueBox.instantiate();
		box.SetText(nextDialogue.text);
		box.SetPortrait(nextDialogue.portrait);
		box.position = Vector2(0, 430);
		add_child(box);

@abstract class Dialogue:
	const YASMEEN: String = "res://Textures/YasmeenPortrait.png";
	static func IntroDialogue():
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Ugh, I am not feeling well.\nMaybe I can brew myself an energy potion.", DialogueManager.Dialogue.YASMEEN));
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("I'd better go outside to gather ingredients.", DialogueManager.Dialogue.YASMEEN));

class DialogueText:
	extends Dialogue
	
	var text: String;
	var portrait: Texture2D;
	
	func _init(text: String, portrait: String):
		self.text = text;
		self.portrait = load(portrait);

class DialogueAction:
	extends Dialogue
	
	var function: Callable;
	var useSeparateThread: bool;
	
	func _init(function: Callable, useSeparateThread: bool = false):
		self.function = function;
		self.useSeparateThread = useSeparateThread;
