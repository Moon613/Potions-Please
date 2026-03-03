extends Node2D

signal clickReleased;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if !event.pressed:
				clickReleased.emit();
	else:
		pass
