extends Area2D
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@export var acorns_scene: PackedScene
var shake_accumulator = 0.0
var is_grabbing = false
var game_active = true
signal ReturnToOverworld(id: int);

func _ready() -> void:
	if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene)

func _input_event(_viewport, event, _shape_idx):
	if game_active and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_grabbing = true
			if timer.is_stopped(): 
				timer.start()
	if is_grabbing and event is InputEventMouseMotion:
		var move_amount = abs(event.relative.x)
		shake_accumulator += move_amount
		if shake_accumulator >= 500.0:
			drop_acorns()
			shake_accumulator = 0.0
func _input(event):
	if not game_active: return

	if event is InputEventMouseButton and not event.pressed:
		is_grabbing = false

	if is_grabbing and event is InputEventMouseMotion:
		sprite.material.set_shader_parameter("shake_intensity", abs(event.relative.x) * 0.5)

func _process(delta):
	if not is_grabbing:
		var current = sprite.material.get_shader_parameter("shake_intensity")
		sprite.material.set_shader_parameter("shake_intensity", lerp(current, 0.0, 5.0 * delta))

func _on_timer_timeout():
	game_active = false
	is_grabbing = false
	print("Minigame Over!")
	ReturnToOverworld.emit(0);

func drop_acorns():
	var acorns = acorns_scene.instantiate()
	acorns.position = Vector2(get_viewport_rect().get_center().x, 0) + Vector2(randf_range(-250, 250), -100)
	get_parent().add_child(acorns)
