extends Area2D
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var timer_label: RichTextLabel = $"../RichTextLabel"
@export var acorns_scene: PackedScene
var shake_accumulator = 0.0
var is_grabbing = false
var game_active = true
var timer_start = false
var time
signal MinigameEnd

func _ready() -> void:
	var time_initial = timer.wait_time
	timer_label.text = "%d:%02d" % [floor(time_initial/60), int(time_initial)%60];
	pass

func _input_event(_viewport, event, _shape_idx):
	if game_active and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_grabbing = true
			if timer.is_stopped(): 
				timer.start()
				timer_start = true
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
	if timer_start:
		time = timer.time_left
		timer_label.text = "%d:%02d" % [floor(time/60), int(time)%60];

	if not is_grabbing:
		var current = sprite.material.get_shader_parameter("shake_intensity")
		sprite.material.set_shader_parameter("shake_intensity", lerp(current, 0.0, 5.0 * delta))

func _on_timer_timeout():
	game_active = false
	is_grabbing = false
	print("Minigame Over!")
	MinigameEnd.emit()
	

func drop_acorns():
	var acorns = acorns_scene.instantiate()
	acorns.position = self.position + Vector2(randf_range(-300, 250), -340)
	get_parent().add_child(acorns)
