extends Area2D
var speed = 300.0
signal AcornDespawned

func _process(delta):
	position.y += speed * delta
	if position.y > 800:
		delete_acorn()

func collect():
	delete_acorn()


func _on_body_entered(body):
	if body.name == "Basket":
		$Sprite2D.visible = false 
		
		if body.has_method("collect"):
			body.collect()

		$AcornCollectedNoise.play()
		await $AcornCollectedNoise.finished
		
		delete_acorn()


func delete_acorn():
	print("acorn gone")
	get_tree().call_group("acornTree", "on_acorn_despawn")
	queue_free()
