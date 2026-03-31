extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = lerp(self.position, get_global_mouse_position(), 0.2);
	
	var closestSpot: Node2D = null;
	for child in get_parent().get_children().filter(func(spot): return spot.is_in_group("Tree Tap Spot")):
		if closestSpot == null or (child.position - self.position).length() < (closestSpot.position - self.position).length():
			closestSpot = child;
	if closestSpot == null:
		return
	var closeness = 1.0 - clamp((self.position - closestSpot.position).length() / 200.0, 0.0, 1.0);
	$AnimatedSprite2D.material.set_shader_parameter("closeness", closeness);
	pass
