extends CanvasLayer

var mapSize: Vector2;
var playerAllowedArea: Vector2 = Vector2(450, 325);
var magicOffset: Vector2 = Vector2(60,60);

# Called when the node enters the scene tree for the first time.
func _ready():
	mapSize = Vector2(114, 106) * $Map.scale;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var playerPosition = get_parent().get_children().filter(func(child: Node): return child.is_in_group("Player"))[0].position + magicOffset;
	$Player.position = playerPosition*(mapSize/playerAllowedArea) + Vector2(get_viewport().get_visible_rect().size)/2;


func _on_button_pressed():
	if !GameInfo.inventory.visible:
		$Map.visible = !$Map.visible;
		$Cave.visible = !$Cave.visible;
		$Bush.visible = !$Bush.visible;
		$House.visible = !$House.visible;
		$Dew.visible = !$Dew.visible;
		$Sap.visible = !$Sap.visible;
		$Acorn.visible = !$Acorn.visible;
		$Player.visible = !$Player.visible;
		GameInfo.busy = !GameInfo.busy;
