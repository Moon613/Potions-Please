extends CanvasLayer

var currentTalkNode: DialogueTrigger = null;
var inDialogue: bool = false;
var potionSelectionOpen: bool = false;
var dialogueQueue: Array[Dialogue] = [];
var dialogueChoices: Dictionary[String, Callable];
var dialogueBox: PackedScene = preload("res://Dialogue Box.tscn");
var previousDialogueDone: bool = true;
signal startMovementTutorial;

# Called when the node enters the scene tree for the first time.
func _ready():
	# Unfortunatly this has to be set here at runtime, due to the way that godot initializes stuff
	dialogueChoices = {
		"EnergyQuestGive": DialogueManager.EnergyQuestGive,
		"EnergyQuestAccept": DialogueManager.EnergyQuestAccept,
		"SleepQuestGive": DialogueManager.SleepQuestGive,
		"SleepQuestAccept": DialogueManager.SleepQuestAccept,
		"StrengthQuestGive": DialogueManager.StrengthQuestGive,
		"StrengthQuestAccept": DialogueManager.StrengthQuestAccept,
		"HealingQuestGive": DialogueManager.HealingQuestGive,
		"HealingQuestAccept": DialogueManager.HealingQuestAccept,
		"ShrinkQuestGive": DialogueManager.ShrinkQuestGive,
		"ShrinkQuestAccept": DialogueManager.ShrinkQuestAccept,
		"MorganaNote": DialogueManager.MorganaNote
	};

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey and event.is_pressed() and !event.is_echo() and $"Morgana Note".visible:
		$"Morgana Note".visible = false;
		get_viewport().set_input_as_handled();
		return;
	if event is InputEvent and event is InputEventKey and event.is_pressed() and !event.is_echo() and inDialogue and ![KEY_A, KEY_S, KEY_D, KEY_W].has(event.keycode) and !potionSelectionOpen and previousDialogueDone:
		previousDialogueDone = false;
		await PlayNextDialogue();
		previousDialogueDone = true;

func AddDialogues(dialogues: Array, portraits: Array):
	for i in dialogues.size():
		AddDialogue(DialogueManager.DialogueText.new(dialogues[i], portraits[clamp(i, 0, portraits.size()-1)]));

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
		# This awaits the function, so if it needs to pause at all it can.
		await nextDialogue.function.call();
		if nextDialogue.skip:
			PlayNextDialogue();

func TriggerDialogue(dialogueChoice: String, originNode: DialogueTrigger = null):
	if originNode != null:
		dialogueChoices[dialogueChoice].call(originNode);
	else:
		dialogueChoices[dialogueChoice].call();

func SpawnPotionSelection():
	potionSelectionOpen = true;
	$PotionSubmissionControl/ItemList.clear();
	for potion: String in GameInfo.potions:
		if potion != GameInfo.RUINED and GameInfo.potions[potion] > 0:
			$PotionSubmissionControl/ItemList.add_item(potion, load(GameInfo.potionToImage[potion]));
	$PotionSubmissionControl.visible = true;
	GameInfo.busy = true;

func _on_potion_submit():
	potionSelectionOpen = false
	inDialogue = false;
	$PotionSubmissionControl.visible = false;
	GameInfo.busy = false;
	if $PotionSubmissionControl/ItemList.item_count <= 0 or $PotionSubmissionControl/ItemList.get_selected_items().size() < 1:
		return;
	var submittedItem = $PotionSubmissionControl/ItemList.get_item_text($PotionSubmissionControl/ItemList.get_selected_items()[0]);
	if GameInfo.questToRequiredPotion[GameInfo.currentQuest] == submittedItem:
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Thanks!", DialogueManager.Dialogue.PLACEHOLDER));
		var nextQuest = GameInfo.ProgressToNextPotionQuest();
		GameInfo.currentQuest = nextQuest;
		DialogueManager.currentTalkNode.DialogueChoice = dialogueChoices.keys()[(nextQuest-1)*2]
		GameInfo.reputation = clamp(GameInfo.reputation+1, 0, 5);
	else:
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("That's not right!", DialogueManager.Dialogue.PLACEHOLDER));
		GameInfo.reputation -= 0.5;
	DialogueManager.currentTalkNode = null;
	GameInfo.potions[submittedItem] -= 1;

func _on_cancel_pressed() -> void:
	inDialogue = false;
	$PotionSubmissionControl.visible = false;
	GameInfo.busy = false;

func IntroDialogue():
	AddDialogues(["There! Bath done!", "That wasn't so bad—right, Nyx?"], [Dialogue.YASMEEN]);
	AddDialogue(DialogueAction.new(func():
		# Whatever I don't care this is too hard to figure out properly just use an absolute path
		var animatedSprite: AnimatedSprite2D = get_node("/root/MainScene/Inside House/Player/AnimatedSprite2D");
		animatedSprite.animation = "Idle Right";
		await get_tree().create_timer(1).timeout;
	));
	AddDialogues(["Morning already?!", "Nyx! I can't believe you kept me up all night...", "That's it, you're staying inside today. I don't want you going outside and getting dirty again", "I'm way too tired...", "Maybe I can get Ms. Morgana to make me an energy elixir or something", "Morgana should be downstairs (Use the WASD keys to move around!)"], [Dialogue.YASMEEN])
	AddDialogue(DialogueAction.new(func(): startMovementTutorial.emit()));
func EnergyQuestGive(originNode: DialogueTrigger):
	DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(
		func(): 
			GameInfo.currentQuest = GameInfo.PotionQuests.ENERGY;
			originNode.DialogueChoice = "EnergyQuestAccept";
	));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Hiiiii there, I really need an energy potion.", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("See, I got a new pet bunny but they keep me up all night, and I can't ignore my other work.", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("So I need something to help keep me awake during the daytimes.", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Thank yoouuuuu!", DialogueManager.Dialogue.PLACEHOLDER));
func EnergyQuestAccept(originNode: DialogueTrigger):
	DialogueManager.currentTalkNode = originNode;
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Oh, did you make me my potion?", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(DialogueManager.SpawnPotionSelection, false));
func SleepQuestGive(originNode: DialogueTrigger):
	DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(
		func():
			GameInfo.currentQuest = GameInfo.PotionQuests.SLEEP;
			originNode.DialogueChoice = "SleepQuestAccept";
	));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("I have a day-long carriage trip ahead of me, and road travel has always made me queasy.", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("I need a potion that’ll help me sleep through the whole thing", DialogueManager.Dialogue.PLACEHOLDER));
func SleepQuestAccept(originNode: DialogueTrigger):
	DialogueManager.currentTalkNode = originNode;
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Oh, did you make me my potion?", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(DialogueManager.SpawnPotionSelection, false));
func StrengthQuestGive(originNode: DialogueTrigger):
	DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(
		func():
			GameInfo.currentQuest = GameInfo.PotionQuests.STRENGTH;
			originNode.DialogueChoice = "StrengthQuestAccept";
	));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("I bet my friend that I could definitely beat them in an arm wrestle. Turns out they’ve been working out daily…", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("I really don’t wanna lose my favorite blanket that I bet them. I need a potion that’ll make me win this arm wrestle.", DialogueManager.Dialogue.PLACEHOLDER));
func StrengthQuestAccept(originNode: DialogueTrigger):
	DialogueManager.currentTalkNode = originNode;
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Oh, did you make me my potion?", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(DialogueManager.SpawnPotionSelection, false));
func HealingQuestGive(originNode: DialogueTrigger):
	DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(
		func():
			GameInfo.currentQuest = GameInfo.PotionQuests.HEALING;
			originNode.DialogueChoice = "HealingQuestAccept";
	));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("I burned my hand in the oven trying to bake my friend a birthday cake! And I burned the cake too!", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("I need a potion that’ll heal my hand quickly so I can make a new cake in time", DialogueManager.Dialogue.PLACEHOLDER));
func HealingQuestAccept(originNode:DialogueTrigger):
	DialogueManager.currentTalkNode = originNode;
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Oh, did you make me my potion?", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(DialogueManager.SpawnPotionSelection, false));
func ShrinkQuestGive(originNode: DialogueTrigger):
	DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(
		func():
			GameInfo.currentQuest = GameInfo.PotionQuests.HEALING;
			originNode.DialogueChoice = "HealingQuestAccept";
	));
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("My friends are definitely talking about me behind my back! I need a potion that’ll help me hide so I can listen in on what they’re saying about me", DialogueManager.Dialogue.PLACEHOLDER));
func ShrinkQuestAccept(originNode: DialogueTrigger):
	DialogueManager.currentTalkNode = originNode;
	DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Oh, did you make me my potion?", DialogueManager.Dialogue.PLACEHOLDER));
	DialogueManager.AddDialogue(DialogueManager.DialogueAction.new(DialogueManager.SpawnPotionSelection, false));
func MorganaNote():
	AddDialogue(DialogueText.new("Huh. What's this? A letter?", Dialogue.YASMEEN));
	AddDialogue(DialogueAction.new(func():
		$"Morgana Note".visible = true;
	, false));

@abstract class Dialogue:
	const YASMEEN: String = "res://Overworld/Textures/YasmeenPortrait.png";
	const PLACEHOLDER: String = "res://Overworld/Textures/PlaceholderPortrait.png";

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
