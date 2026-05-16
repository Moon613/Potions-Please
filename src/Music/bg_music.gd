extends AudioStreamPlayer

const OVERWORLD_MUSIC = preload("uid://da1nxj0mh08f1")
@onready var ambience: AudioStreamPlayer = $ambience
const fall_ambience = preload("uid://b0jbir7mqqu1s")
@onready var loop_timer: Timer = $LoopTimer
var currentScene: int

var sceneID
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_scene_change(oldScene: int, newScene: int):
	currentScene = newScene
	if (newScene == GameInfo.SceneID.MAINMENU):
		stop()
		ambience.stop()
	elif (oldScene == GameInfo.SceneID.MAINMENU):
		stream = OVERWORLD_MUSIC
		play()
		ambience.stream = fall_ambience
		ambience.play()
	if (newScene == GameInfo.SceneID.UPSTAIRS):
		set_bus("ExtraMuffled")
		ambience.set_bus("ExtraMuffled")
	if (newScene == GameInfo.SceneID.INSIDEHOUSE or newScene == GameInfo.SceneID.POTIONBREWING):
		set_bus("Muffled")
		ambience.set_bus("Muffled")
	if (newScene == GameInfo.SceneID.OVERWORLD):
		set_bus("Master")
		ambience.set_bus("Master")
	if (newScene == GameInfo.SceneID.MANDRAKES or 
		newScene == GameInfo.SceneID.DEWDROPS or 
		newScene == GameInfo.SceneID.ACORNS or 
		newScene == GameInfo.SceneID.TREESAP):
			set_bus("Minigame")
			ambience.set_bus("Minigame")
	if (newScene == GameInfo.SceneID.DRAGONEGGS):
		set_bus("Cave")
		ambience.set_bus("Cave")
	


func _on_finished() -> void:
	loop_timer.start()
	pass # Replace with function body.


func _on_loop_timer_timeout() -> void:
	if currentScene != GameInfo.SceneID.MAINMENU:
		play()
	pass # Replace with function body.
