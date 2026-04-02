extends StaticBody2D

signal PlaceTap(spot: Node2D);
var canPlaceMoretaps: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = lerp(self.position, get_global_mouse_position(), 0.2);
	
	var closestSpot: Node2D = null;
	for child in get_parent().get_children().filter(func(spot): return spot.is_in_group("Tree Tap Spot") and !spot.is_in_group("Already Tapped")):
		if closestSpot == null or (child.position - self.position).length() < (closestSpot.position - self.position).length():
			closestSpot = child;
	if closestSpot == null:
		return
	var closeness = 1.0 - clamp((self.position - closestSpot.position).length() / 200.0, 0.0, 1.0);
	$AnimatedSprite2D.material.set_shader_parameter("closeness", closeness);
	
	if closeness >= 0.7 and $AnimatedSprite2D.animation == "Far":
		var frameBefore = $AnimatedSprite2D.frame;
		var progress = $AnimatedSprite2D.frame_progress;
		$AnimatedSprite2D.animation = "Close";
		$AnimatedSprite2D.set_frame_and_progress(frameBefore, progress);
	elif closeness < 0.7 and $AnimatedSprite2D.animation == "Close":
		var frameBefore = clamp($AnimatedSprite2D.frame, 0, 1);
		var progress = $AnimatedSprite2D.frame_progress;
		$AnimatedSprite2D.animation = "Far";
		$AnimatedSprite2D.set_frame_and_progress(frameBefore, progress);
	pass

func _input(event: InputEvent) -> void:
	if canPlaceMoretaps and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		PlaceTap.emit(self.position);

func _on_minigame_drain_taps() -> void:
	canPlaceMoretaps = false;
	self.visible = false;
