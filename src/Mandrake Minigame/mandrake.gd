extends Area2D

@onready var mandrake_hurtbox: CollisionShape2D = $MandrakeHurtbox
@onready var mandrake_animations: AnimatedSprite2D = $MandrakeAnimations
@onready var activation_timer: Timer = $ActivationTimer
@onready var shake_timer: Timer = $ShakeTimer
@onready var uproot_timer: Timer = $UprootTimer
@onready var despawn_timer: Timer = $DespawnTimer

@export var speed_min: float = 5
@export var speed_max: float = 10
@export var timer_min: float = 1
@export var timer_max: float = 10
var wakeup_time = 1
var speed = 1
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mandrake_animations.play("idle")
	mandrake_hurtbox.disabled = true
	speed = randf_range(speed_min, speed_max)
	wakeup_time = randf_range(timer_min, timer_max)
	activation_timer.wait_time = wakeup_time
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mandrake_animations.animation == "run":
		position.x += speed * direction
		pass
	pass
	

#after random amount of time, play shake animation
#shake for set amount fo time, then play popup animation
#then activate hurtbox and run animation
#random direction and random speed
#if collision, play death animation, deactivate hurtbox
#despawn after animation


func _on_activation_timer_timeout() -> void:
	top_level = true
	mandrake_animations.play("shake")
	shake_timer.start()
	pass # Replace with function body.


func _on_shake_timer_timeout() -> void:
	mandrake_animations.play("uproot")
	uproot_timer.start()
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hammer") and despawn_timer.is_stopped():
		print("ded")
		mandrake_animations.scale = Vector2(0.25, 0.25)
		mandrake_animations.play("ded")
		despawn_timer.start()
	pass # Replace with function body.


func _on_despawn_timer_timeout() -> void:
	self.queue_free()
	pass # Replace with function body.


func _on_uproot_timer_timeout() -> void:
	mandrake_animations.play("run")
	mandrake_hurtbox.disabled = false
	direction = randi_range(0, 1)
	if direction == 0:
		direction = -1
	mandrake_animations.flip_h = (direction < 0)
	pass # Replace with function body.
