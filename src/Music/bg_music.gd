extends AudioStreamPlayer

const OVERWORLD = preload("uid://da1nxj0mh08f1")

var sceneID
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_scene_change(oldScene: int, newScene: int):
	if (newScene == GameInfo.SceneID.MAINMENU):
		stop()
	elif (oldScene == GameInfo.SceneID.MAINMENU):
		stream = OVERWORLD
		play()
	if (newScene == GameInfo.SceneID.UPSTAIRS):
		set_bus("ExtraMuffled")
	if (newScene == GameInfo.SceneID.INSIDEHOUSE or newScene == GameInfo.SceneID.POTIONBREWING):
		set_bus("Muffled")
	if (newScene == GameInfo.SceneID.OVERWORLD):
		set_bus("Master")
	if (newScene == GameInfo.SceneID.MANDRAKES or 
		newScene == GameInfo.SceneID.DEWDROPS or 
		newScene == GameInfo.SceneID.ACORNS or 
		newScene == GameInfo.SceneID.TREESAP):
			set_bus("Minigame")
	if (newScene == GameInfo.SceneID.DRAGONEGGS):
		set_bus("Cave")
