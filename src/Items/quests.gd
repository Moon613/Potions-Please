extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if visible and !DialogueManager.inDialogue:
		if Input.is_action_pressed("ui_cancel"):
			visible = false;
		get_viewport().set_input_as_handled();
