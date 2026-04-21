extends CanvasLayer

@onready var page_1: TextureRect = $Control/Page1
@onready var page_2: TextureRect = $Control/Page2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_cancel") and GameInfo.busy:
		get_viewport().set_input_as_handled()
		visible = false
		GameInfo.busy = false
		
func _on_next_page_button_up() -> void:
	page_2.visible = true
	page_1.visible = false


func _on_previous_page_button_up() -> void:
	page_1.visible = true
	page_2.visible = false
