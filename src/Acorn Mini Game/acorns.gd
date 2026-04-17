extends Area2D
var speed = 300.0

func _process(delta):
	position.y += speed * delta
	if position.y > 800:
		queue_free()

func collect():
	queue_free()


func _on_body_entered(body):
	if body.name == "Basket":
		$Sprite2D.visible = false 
		
		if body.has_method("collect"):
			body.collect()

		$AcornCollectedNoise.play()
		await $AcornCollectedNoise.finished
		
		queue_free()
