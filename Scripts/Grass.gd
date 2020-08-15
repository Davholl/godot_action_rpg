extends Node2D

func _on_Hurtbox_area_entered(area):
	destroy_grass_effect();	
	queue_free();

func destroy_grass_effect():
	var grassEffect = load("res://Scenes/GrassEffect.tscn");
	var grassEffectInstance = grassEffect.instance();
	var main = get_tree().current_scene;
		
	grassEffectInstance.position.x = position.x;
	grassEffectInstance.position.y = position.y;
		
	main.add_child(grassEffectInstance);
