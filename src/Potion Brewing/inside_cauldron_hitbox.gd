extends Area2D

signal StartStirring
signal ConsumeIngredient(type: String)
signal WaterlogSpoonToggle

var startedStirring: bool = false
@onready var brewing_noise = $BrewingNoise

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	var bodies = get_overlapping_bodies()
	var spoon_present = false
	
	for body in bodies:
		if body.is_in_group("Draggable Ingredients"):
			BrewingIngredient.picked = false
			ConsumeIngredient.emit(body.Type)
			body.queue_free()
		
		if body.is_in_group("Spoon"):
			spoon_present = true
			if !startedStirring:
				print("Started Stirring")
				StartStirring.emit()
				startedStirring = true

	if spoon_present and !brewing_noise.playing:
		brewing_noise.play()
	elif !spoon_present and brewing_noise.playing:
		brewing_noise.stop()

func _on_body_entered(body: Node2D):
	if body.is_in_group("Spoon"):
		WaterlogSpoonToggle.emit()

func _on_body_exited(body: Node2D):
	if body.is_in_group("Spoon"):
		WaterlogSpoonToggle.emit()
