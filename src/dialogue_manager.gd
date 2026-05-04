extends CanvasLayer

var inDialogue: bool = false;
var potionSelectionOpen: bool = false;
# This is used when going from the quest selection UI to the potion selection UI, to keep track of which quest is being submitted for
var selectedQuest: int = 0;
var dialogueQueue: Array[Dialogue] = [];
var dialogueChoices: Dictionary[String, Callable];
var dialogueBox: PackedScene = preload("res://Dialogue Box.tscn");
var previousDialogueDone: bool = true;
signal startMovementTutorial;
signal OpenJournalFromDialogue;

# Called when the node enters the scene tree for the first time.
func _ready():
	# Unfortunatly this has to be set here at runtime, due to the way that godot initializes stuff
	dialogueChoices = {
		"EnergyQuestGive": DialogueManager.EnergyQuestGive,
		"SleepQuestGive": DialogueManager.SleepQuestGive,
		"StrengthQuestGive": DialogueManager.StrengthQuestGive,
		"HealingQuestGive": DialogueManager.HealingQuestGive,
		"ShrinkQuestGive": DialogueManager.ShrinkQuestGive,
		"MorganaNote": DialogueManager.MorganaNote,
		"PotionBookGet": DialogueManager.PotionBookGet,
		"GatherDewdropsFirst": DialogueManager.GatherDewdropsFirst,
		"OpenQuestMenu": DialogueManager.OpenQuestMenu
	};
	OpenJournalFromDialogue.connect(GameInfo._on_inventory_journal_open);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey and event.is_pressed() and !event.is_echo() and $"Morgana Note".visible:
		$"Morgana Note".visible = false;
		get_viewport().set_input_as_handled();
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
	if GameInfo.currentQuests[selectedQuest].potion == submittedItem:
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("Thanks!", DialogueManager.Dialogue.PLACEHOLDER));
		GameInfo.reputation = clamp(GameInfo.reputation+1, 0, 5);
	else:
		DialogueManager.AddDialogue(DialogueManager.DialogueText.new("That's not right!", DialogueManager.Dialogue.PLACEHOLDER));
		GameInfo.reputation -= 0.5;
	# Remove the quest, completed or failed, and remove the potion that was used for submission.
	GameInfo.currentQuests.remove_at(selectedQuest);
	GameInfo.potions[submittedItem] -= 1;

func _on_quest_selection(button: Button):
	$QuestSelection.visible = false;
	selectedQuest = $QuestSelection/ScrollContainer/VBoxContainer.get_children().find(button);
	for child in $QuestSelection/ScrollContainer/VBoxContainer.get_children():
		child.queue_free();
	SpawnPotionSelection();

func _on_cancel_pressed() -> void:
	inDialogue = false;
	$PotionSubmissionControl.visible = false;
	$QuestSelection.visible = false;
	potionSelectionOpen = false;
	selectedQuest = 0;
	for child in $QuestSelection/ScrollContainer/VBoxContainer.get_children():
		child.queue_free();
	GameInfo.busy = false;

func _on_recive_quest_pressed():
	potionSelectionOpen = false;
	selectedQuest = 0;
	$QuestSelection.visible = false;
	for child in $QuestSelection/ScrollContainer/VBoxContainer.get_children():
		child.queue_free();
	GameInfo.busy = false;
	
	match randi_range(0, 4):
		0:
			EnergyQuestGive();
		1:
			SleepQuestGive();
		2:
			StrengthQuestGive();
		3:
			HealingQuestGive();
		4:
			ShrinkQuestGive();
		_:
			pass

func IntroDialogue():
	AddDialogues(["There! Bath done!", "That wasn't so bad—right, Nyx?"], [Dialogue.YASMEEN]);
	AddDialogue(DialogueAction.new(func():
		# Whatever I don't care this is too hard to figure out properly just use an absolute path
		var animatedSprite: AnimatedSprite2D = get_tree().get_nodes_in_group("Player")[0].get_node("AnimatedSprite2D");
		animatedSprite.animation = "Idle Up";
		await get_tree().create_timer(1).timeout;
	));
	AddDialogues(["Morning already?!", "Nyx! I can't believe you kept me up all night...", "That's it, you're staying inside today. I don't want you going outside and getting dirty again", "I'm way too tired...", "Maybe I can get Ms. Morgana to make me an energy elixir or something", "Morgana should be downstairs (Use the WASD keys to move around!)"], [Dialogue.YASMEEN])
	AddDialogue(DialogueAction.new(func(): startMovementTutorial.emit()));
func OpenQuestMenu(originNode: DialogueTrigger):
	potionSelectionOpen = true;
	for quest: GameInfo.Quest in GameInfo.currentQuests:
		var button = Button.new();
		button.custom_minimum_size = Vector2(480, 90);
		button.icon = quest.texture;
		button.pressed.connect(_on_quest_selection.bind(button));
		button.expand_icon = true;
		$QuestSelection/ScrollContainer/VBoxContainer.add_child(button);
	$QuestSelection.visible = true;
func EnergyQuestGive():
	var texture = GameInfo.GenerateQuest(GameInfo.ENERGY);
	AddDialogues(["Hiiiii there, I really need an energy potion.", "See, I got a new pet bunny but they keep me up all night, and I can't ignore my other work.", "So I need something to help keep me awake during the daytimes.", "Thank yoouuuuu!"], [texture])
func SleepQuestGive():
	var texture = GameInfo.GenerateQuest(GameInfo.SLEEP);
	AddDialogues(["I have a day-long carriage trip ahead of me, and road travel has always made me queasy.", "I need a potion that’ll help me sleep through the whole thing"], [texture]);
func StrengthQuestGive():
	var texture = GameInfo.GenerateQuest(GameInfo.STRENGTH);
	AddDialogues(["I bet my friend that I could definitely beat them in an arm wrestle. Turns out they’ve been working out daily…", "I really don’t wanna lose my favorite blanket that I bet them. I need a potion that’ll make me win this arm wrestle."], [texture]);
func HealingQuestGive():
	var texture = GameInfo.GenerateQuest(GameInfo.HEALING);
	AddDialogues(["I burned my hand in the oven trying to bake my friend a birthday cake! And I burned the cake too!", "I need a potion that’ll heal my hand quickly so I can make a new cake in time"], [texture]);
func ShrinkQuestGive():
	var texture = GameInfo.GenerateQuest(GameInfo.SHRINK);
	AddDialogues(["My friends are definitely talking about me behind my back! I need a potion that’ll help me hide so I can listen in on what they’re saying about me"], [texture]);
func MorganaNote():
	AddDialogue(DialogueText.new("Huh. What's this? A letter?", Dialogue.YASMEEN));
	AddDialogue(DialogueAction.new(func():
		$"Morgana Note".visible = true;
	, false));
	AddDialogues(["THE ENTIRE SHOP?!", "I haven't even mastered potion brewing yet!", "Well, nother I can do about it...", "[b]I better make my way downstairs and grab that recipe book... and I guess brew myself that energy elixir[/b]"], [Dialogue.YASMEEN]);
func PotionBookGet():
	AddDialogue(DialogueText.new("Looks like she left the potion book for me on the front counter. Thank goodness.", Dialogue.YASMEEN));
	AddDialogue(DialogueAction.new(func():
		var node: Node = Node.new();
		node.set_script(load("res://player gather potion book.gd"));
		add_child(node);
	, true));
func GrabPotionBook():
	AddDialogue(DialogueAction.new(func():
		GameInfo._on_inventory_journal_open();
	));
	AddDialogue(DialogueText.new("Ah, great, here's the Energy Elixir recipe. Seems simple enough.", Dialogue.YASMEEN));
func HeadToCaludron():
	AddDialogue(DialogueText.new("[b]Let me head to the cauldron and brew it.[/b]", Dialogue.YASMEEN))
func FirstTutorialPotionAttempt():
	# This is a workaround for ??? Idk having it here works ¯\_(ツ)_/¯
	AddDialogue(DialogueText.new(""));
	AddDialogue(DialogueText.new("Okay, let me take a look at that recipe one more time.", Dialogue.YASMEEN));
	AddDialogue(DialogueAction.new(func():
		OpenJournalFromDialogue.emit();
	));
func ListIngredientsForFirstPotion():
	AddDialogues(["Honey... we got that.", "Ginger root... got that too.", "Morning dew...", "Wait, where's the morning dew?", "Oh right, Morgana used the rest of it the other day.", "She hand-collects some of her ingredients, doesn't she?", "[b]I should go outside to collect some morning dew.[/b]"], [Dialogue.YASMEEN]);
	AddDialogue(DialogueAction.new(func():
		inDialogue = false;
	, false));
func GatherDewdropsFirst():
	AddDialogue(DialogueText.new("I don't think I'll find morning dew over there!", Dialogue.YASMEEN));

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
