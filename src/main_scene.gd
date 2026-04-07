class_name MainScene
extends Node2D
@export var overworld: PackedScene = preload("res://Overworld/overworld.tscn")
@export var potionBrewing: PackedScene = preload("res://Potion Brewing/potion_brewing.tscn")
@export var insideHouse: PackedScene = preload("res://Overworld/inside_house.tscn")
@export var dewdrops: PackedScene = preload("res://Dewdrop Minigame/minigame.tscn")
@export var mainMenu: PackedScene = preload("res://Main Menu/Main Menu.tscn")
@export var acorns: PackedScene = preload("res://Acorn Mini Game/acorn.tscn")
@export var treesap: PackedScene = preload("res://Treesap Minigame/minigame.tscn")
<<<<<<< HEAD
@export var dragonEggs: PackedScene = preload("res://Dragon Egg Minigame/minigame.tscn")
=======
@export var mandrakes: PackedScene = preload("res://Mandrake Minigame/MandrakeMinigame.tscn")
>>>>>>> 549c6ff (created mandrake minigame)

@export var startingScene: int;

@export var busy_scenes = [1, 3, 4, 5, 6, 7]
var overworldScene;
var potionScene;
var insideScene;
var dewdropScene;
var mainMenuScene;
var acornScene;
var sapScene;
<<<<<<< HEAD
var eggScene;
=======
var mandrakeScene;
>>>>>>> 549c6ff (created mandrake minigame)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var overworldInstance = overworld.instantiate();
	overworldInstance.name = "Overworld";
	
	var brewingInstance = potionBrewing.instantiate();
	brewingInstance.name = "Potion Brewing";
	
	var insideInstance = insideHouse.instantiate();
	insideInstance.name = "Inside House";
	
	var dewdropInstance = dewdrops.instantiate();
	dewdropInstance.name = "Dewdrop Collecting";
	
	var mainMenuInstance = mainMenu.instantiate();
	mainMenuInstance.name = "Main Menu";
	
	var acornInstance = acorns.instantiate();
	acornInstance.name = "Acorn Minigame"
	
	var sapInstance = treesap.instantiate();
	sapInstance.name = "Treesap Minigame"
	
<<<<<<< HEAD
	var eggInstance = dragonEggs.instantiate();
	eggInstance.name = "Dragon Eggs Minigame"
=======
	var mandrakeInstance = mandrakes.instantiate();
	mandrakeInstance.name = "Mandrake Minigame"
>>>>>>> 549c6ff (created mandrake minigame)
	
	add_child(mainMenuInstance);
	
	overworldScene = overworldInstance;
	potionScene = brewingInstance;
	insideScene = insideInstance;
	dewdropScene = dewdropInstance;
	mainMenuScene = mainMenuInstance;
	acornScene = acornInstance;
	sapScene = sapInstance;
<<<<<<< HEAD
	eggScene = eggInstance;
=======
	mandrakeScene = mandrakeInstance;
>>>>>>> 549c6ff (created mandrake minigame)
	
	if startingScene != -1:
		_switch_scene(startingScene);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _switch_scene(id: int):
	print("Switching to scene " + str(id))
	if self.get_children()[0].has_method("Reset"):
		self.get_children()[0].Reset();
	self.remove_child(self.get_children()[0]);
	inv_panel_control(id)
	match id:
		0:
			self.add_child(overworldScene);
		1:
			self.add_child(potionScene);
		2:
			self.add_child(insideScene);
		3:
			self.add_child(dewdropScene);
		4:
			self.add_child(mainMenuScene);
		5:
			self.add_child(acornScene);
		6:
			Input.warp_mouse(get_viewport_rect().size * 0.5);
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
			self.add_child(sapScene);
		7:
<<<<<<< HEAD
			Input.warp_mouse(get_viewport_rect().size * 0.5);
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
			self.add_child(eggScene);
=======
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
			self.add_child(mandrakeScene);
>>>>>>> 549c6ff (created mandrake minigame)
		_:
			print("Unknown SceneID!")

func inv_panel_control(id: int):
	if id in busy_scenes:
		GameInfo.inventory.visible = false
		GameInfo.busy = true
	else:
		GameInfo.busy = false
