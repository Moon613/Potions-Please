# Potions-Please
UMBC 493 Game Prototype

Welcome to the CMSC493/ART485 Group Project!

All code and project source is in the src folder.

# Opening the source and running as Debug

To run the project from source, open the project.godot in the Godot 4.6.

In the Godot editor, open the MainScene.tscn scene and run it with F6.

# Code Style

- Every Scene has a root node in it, that is parent to every other node in the scene.
- If making a Scene that can be loaded into via player interaction, IE a minigame or overworld transition, put the following code in the \_ready function and make sure it has a matching signal declared in code. In this case, ReturnToOverworld is the signal. It should have an integer argument.
`if get_tree().current_scene and get_tree().current_scene.has_method("_switch_scene"):
		ReturnToOverworld.connect(get_tree().current_scene._switch_scene)`
- New areas or minigames should each have their own folder.