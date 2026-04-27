extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _make_custom_tooltip(for_text: String) -> Object:
	var style_box: StyleBoxFlat = StyleBoxFlat.new();
	style_box.set_bg_color(Color(1, 1, 0));
	style_box.set_border_width_all(2);
	
	return style_box;
