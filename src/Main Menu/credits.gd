extends Control

var creditsLabel: PackedScene = preload("res://Main Menu/CreditsText.tscn");
var fadeInTimer: float = 0;
var show: bool = false;
var credits: Array[String] = [
	"Alexander Mosko",
	"Elijah Manning",
	"Megan Gregory",
	"Mino Yevdayev",
	"Priscilia Herrera",
	"Tim Reiss",
	"William Zendgraft"
];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if show:
		self.modulate.a = clamp(modulate.a + delta*2, 0, 1);
		
		if self.modulate.a >= 1:
			ShowNames();
			show = false;
	
	if !show and !self.get_children().any(func(child): return child.is_in_group("Credits Text")):
		self.modulate.a = clamp(modulate.a - delta*2, 0, 1);
		self.mouse_filter = Control.MOUSE_FILTER_IGNORE;

func ShowNames():
	$Splash.emitting = true;
	for i in credits.size():
		var c: CreditsText = creditsLabel.instantiate();
		c.Setup(-1 if i%2==0 else 1, get_viewport_rect(), credits[i]);
		c.add_to_group("Credits Text");
		add_child(c);
		if i == credits.size()-1:
			$Splash.emitting = false;
		await get_tree().create_timer(2.0).timeout;

func _on_main_menu_credits():
	self.mouse_filter = Control.MOUSE_FILTER_STOP;
	show = true;
