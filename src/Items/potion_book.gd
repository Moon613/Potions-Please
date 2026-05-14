extends CanvasLayer

@onready var energy: TextureRect = $Control/Energy
@onready var healing: TextureRect = $Control/Healing
@onready var shrink: TextureRect = $Control/Shrink
@onready var sleep: TextureRect = $Control/Sleep
@onready var strength: TextureRect = $Control/Strength

var currentPage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentPage = energy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if visible and !DialogueManager.inDialogue:
		if Input.is_action_just_pressed("ui_cancel"):
			_on_exit_pressed();
			get_viewport().set_input_as_handled()


func _on_tab_energy_button_up() -> void:
	currentPage.visible = false
	energy.visible = true
	currentPage = energy


func _on_tab_healing_button_up() -> void:
	currentPage.visible = false
	healing.visible = true
	currentPage = healing


func _on_tab_shrink_button_up() -> void:
	currentPage.visible = false
	shrink.visible = true
	currentPage = shrink


func _on_tab_sleep_button_up() -> void:
	currentPage.visible = false
	sleep.visible = true
	currentPage = sleep


func _on_tab_strength_button_up() -> void:
	currentPage.visible = false
	strength.visible = true
	currentPage = strength


func _on_exit_pressed() -> void:
	if !GameInfo.seenPotionBookFirstTime and GameInfo.goToCauldron:
		GameInfo.seenPotionBookFirstTime = true;
		DialogueManager.HeadToCaludron();
	elif !GameInfo.closedPotionBookInBrewing and GameInfo.seenPotionBrewingScreen:
		GameInfo.closedPotionBookInBrewing = true;
		DialogueManager.ListIngredientsForFirstPotion();
	GameInfo.journal_is_open = false;
	visible = false


func _on_visibility_changed() -> void:
	if GameInfo:
		if visible:
			GameInfo.journal_is_open = true
		else:
			GameInfo.journal_is_open = false
