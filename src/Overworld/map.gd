extends CanvasLayer

var mapSize: Vector2;
var playerAllowedArea: Vector2 = Vector2(225, 325);

# Called when the node enters the scene tree for the first time.
func _ready():
	mapSize = Vector2(114, 106)*0.65 * $Map.scale;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
		var playerPosition = get_parent().get_children().filter(func(child: Node): return child.is_in_group("Player"))[0].position;
		$Player.position = (playerPosition+Vector2(50,115))*(mapSize/playerAllowedArea) + Vector2(get_viewport().size)/2;
		GameInfo.busy = !GameInfo.busy;
