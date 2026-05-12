extends StaticBody2D

signal PlaceTap(spot: Node2D);
var canPlaceMoretaps: bool = true;
var currentCloseness: float = 0;
var rating: PackedScene = preload("res://Treesap Minigame/rating.tscn");

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
	currentCloseness = 1.0 - clamp((self.position - closestSpot.position).length() / 200.0, 0.0, 1.0);
	$AnimatedSprite2D.material.set_shader_parameter("closeness", currentCloseness);
	
	# These are for flipping between the far and close animations while preserving frame progress.
	if currentCloseness >= 0.7 and $AnimatedSprite2D.animation == "Far":
		var frameBefore = $AnimatedSprite2D.frame;
		var progress = $AnimatedSprite2D.frame_progress;
		$AnimatedSprite2D.animation = "Close";
		$AnimatedSprite2D.set_frame_and_progress(frameBefore, progress);
	elif currentCloseness < 0.7 and $AnimatedSprite2D.animation == "Close":
		var frameBefore = clamp($AnimatedSprite2D.frame, 0, 1);
		var progress = $AnimatedSprite2D.frame_progress;
		$AnimatedSprite2D.animation = "Far";
		$AnimatedSprite2D.set_frame_and_progress(frameBefore, progress);
	

func _input(event: InputEvent) -> void:
	if canPlaceMoretaps and event is InputEventMouseButton and event.button_index == 1 and event.pressed and !$"../InfoButton".is_hovered():
		PlaceTap.emit(self.position);
		var ratingInstance = rating.instantiate();
		if currentCloseness < 0.25:
			ratingInstance.SetSprite(0);
		elif currentCloseness < 0.5:
			ratingInstance.SetSprite(1);
		elif currentCloseness < 0.75:
			ratingInstance.SetSprite(2);
		else:
			ratingInstance.SetSprite(3);
		ratingInstance.position = self.position + Vector2(0,-40);
		get_parent().add_child(ratingInstance);

func _on_minigame_drain_taps() -> void:
	canPlaceMoretaps = false;
	self.visible = false;
