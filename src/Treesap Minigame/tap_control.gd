extends StaticBody2D

signal PlaceTap(spot: Node2D);
var canPlaceMoretaps: bool = true;
var currentCloseness: float = 0;
var rating: PackedScene = preload("res://Treesap Minigame/rating.tscn");

func _ready():
	# Start the radar loop immediately if you want it constant
	$TreeRadar.play()

func _process(delta):
	self.position = lerp(self.position, get_global_mouse_position(), 0.2);
	
	var closestSpot: Node2D = null;
	for child in get_parent().get_children().filter(func(spot): return spot.is_in_group("Tree Tap Spot") and !spot.is_in_group("Already Tapped")):
		if closestSpot == null or (child.position - self.position).length() < (closestSpot.position - self.position).length():
			closestSpot = child;

	if closestSpot == null:
		$TreeRadar.volume_db = -80 # Mute if no spots left
		return
	else:
		$TreeRadar.volume_db = 0

	currentCloseness = 1.0 - clamp((self.position - closestSpot.position).length() / 200.0, 0.0, 1.0);
	
	# Update Radar Sound: Pitch increases as you get closer (1.0 to 3.0 range)
	$TreeRadar.pitch_scale = 1.0 + (currentCloseness * 2.0)
	
	$AnimatedSprite2D.material.set_shader_parameter("closeness", currentCloseness);

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
		# Play Tapping Sound
		$TappingNoise.play()
		
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
	$TreeRadar.stop() # Stop the radar when the game ends
