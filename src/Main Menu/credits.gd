extends Control

var creditsLabel: PackedScene = preload("res://Main Menu/CreditsText.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_credits():
	visible = true;
	var c: CreditsText = creditsLabel.instantiate();
	c.direction = 1;
	c.pivot_offset = c.size * 0.5;
	c.start = true;
	add_child(c);
