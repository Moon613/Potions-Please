extends CanvasLayer

var inDialogue: bool = false;
var dialogueQueue: Array[Dialogue] = [];
var dialogueChoices: Dictionary[String, Callable] = {
	"EnergyQuestGive": Dialogue.EnergyQuestGive,
	"EnergyQuestAccept": Dialogue.EnergyQuestAccept
};
var dialogueBox: PackedScene = preload("res://Dialogue Box.tscn");
signal startMovementTutorial;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEvent and event is InputEventKey and event.is_pressed() and !event.is_echo() and inDialogue and ![KEY_A, KEY_S, KEY_D, KEY_W].has(event.keycode):
		PlayNextDialogue();

func AddDialogue(dialogue: Dialogue):
	dialogueQueue.append(dialogue);
	if !inDialogue:
		inDialogue = true;
		GameInfo.busy = true;
		PlayNextDialogue();

func PlayNextDialogue():
	if dialogueQueue.is_empty():
		inDialogue = false;
		GameInfo.busy = false;
		return;
	var nextDialogue: Dialogue = dialogueQueue.pop_front();
	if nextDialogue is DialogueText:
		var box: DialogueBox = dialogueBox.instantiate();
		box.SetText(nextDialogue.text);
		box.SetPortrait(nextDialogue.portrait);
		box.position = Vector2(0, 430);
		add_child(box);
	elif nextDialogue is DialogueAction:
		nextDialogue.function.call();
		if nextDialogue.skip:
			PlayNextDialogue();

func TriggerDialogue(dialogueChoice: String, originNode: DialogueTrigger):
	dialogueChoices[dialogueChoice].call(originNode);

func SpawnPotionSelection():
	$Control/ItemList.clear();
	for potion: String in GameInfo.potions:
		if potion != GameInfo.RUINED and GameInfo.potions[potion] > 0:
			$Control/ItemList.add_item(potion, load(GameInfo.potionToImage[potion]));
	$Control.visible = true;
	GameInfo.busy = true;

func _on_potion_submit():
	$Control.visible = false;
	GameInfo.busy = false;
	if $Control/ItemList.item_count <= 0:
		return;
	var submittedItem = $Control/ItemList.get_item_text($Control/ItemList.get_selected_items()[0]);
	if GameInfo.questToRequiredPotion[GameInfo.currentQuest] == submittedItem:
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Thanks!", DialogueManager.Dialogue.PLACEHOLDER));
		GameInfo.currentQuest = GameInfo.PotionQuests.NONE;
		GameInfo.reputation = clamp(GameInfo.reputation+1, 0, 5);
	else:
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("That's not right!", DialogueManager.Dialogue.PLACEHOLDER));
		GameInfo.reputation -= 0.5;
	GameInfo.potions[submittedItem] -= 1;

func _on_cancel_pressed() -> void:
	$Control.visible = false;
	GameInfo.busy = false;

@abstract class Dialogue:
	const YASMEEN: String = "res://Textures/YasmeenPortrait.png";
	const PLACEHOLDER: String = "res://Textures/PlaceholderPortrait.png";
	static func IntroDialogue():
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Ugh, I am not feeling well.\nMaybe I can brew myself an energy potion.", YASMEEN));
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("I'd better go outside to gather ingredients.", YASMEEN));
		DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(func(): DialogueManager.startMovementTutorial.emit()));
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("(Use the WASD keys to move around!)", YASMEEN));
	static func EnergyQuestGive(originNode: DialogueTrigger):
		DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(
			func(): 
				GameInfo.currentQuest = GameInfo.PotionQuests.ENERGY;
				originNode.DialogueChoice = "EnergyQuestAccept";
		));
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Hiiiii there, I really need an energy potion.", PLACEHOLDER));
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("See, I got a new pet bunny but they keep me up all night, and I can't ignore my other work.", PLACEHOLDER));
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("So I need something to help keep me awake during the daytimes.", PLACEHOLDER));
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Thank yoouuuuu!", PLACEHOLDER));
	static func EnergyQuestAccept(originNode: DialogueTrigger):
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Oh, did you make me my potion?", PLACEHOLDER));
		DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(DialogueManager.SpawnPotionSelection));

class DialogueText:
	extends Dialogue
	
	var text: String;
	var portrait: Texture2D;
	
	func _init(text: String, portrait: String = DialogueManager.Dialogue.YASMEEN):
		self.text = text;
		self.portrait = load(portrait);

class DialogueAction:
	extends Dialogue
	
	var function: Callable;
	var useSeparateThread: bool;
	var skip: bool;
	
	func _init(function: Callable, skip: bool = true, useSeparateThread: bool = false):
		self.function = function;
		self.useSeparateThread = useSeparateThread;
		self.skip = skip;
