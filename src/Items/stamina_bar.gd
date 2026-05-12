extends TextureProgressBar
@onready var flash_timer: Timer = $FlashTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	InputEvent
	pass

func flashStamina():
	for i in range(0, 1):
		tint_under = Color(18, 18, 18, 1)
		tint_progress = Color(18, 18, 18, 1)
		flash_timer.start()
		while(!flash_timer.is_stopped()):
			pass
		tint_under = Color(1, 1, 1, 1)
		tint_progress = Color(1, 1, 1, 1)
		flash_timer.start()
		while(!flash_timer.is_stopped()):
			pass
	pass
