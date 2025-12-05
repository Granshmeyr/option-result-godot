extends Node

func _ready() -> void:
	var enemy_weakness: String = "fire" if randi_range(0, 1) == 0 else "water"
	var missed: bool = randi_range(0, 100) < 30
	var base_dmg: Oint = Oint.Some(5) if not missed else Oint.None()
	var applied_dmg: Oint = Chain.to(Oint).do(
		Chain.start(base_dmg),
		Oint.map_to_c(_apply_strength_bonus),
		Oint.map_to_c(_apply_armor_reduction),
		Oint.map_to_c(_apply_critical_hit),
		Oint.map_to_c(func (dmg: int) -> int:
			return dmg + _get_weakness_bonus(enemy_weakness),
		),
	)
	
	var result: String = Oint.match(applied_dmg)\
		.to(&"String").do(
			func s (dmg: int) -> String: return "Enemy took %s damage!" % dmg,
			func n () -> String: return "Enemy dodged the attack!",
		)
	
	print("Option chain result:\n\t%s" % result)


func _apply_strength_bonus(dmg: int) -> int:
	return dmg + 20


func _apply_armor_reduction(dmg: int) -> int:
	return floori(float(dmg) * randf_range(0.2, 0.8))


func _apply_critical_hit(dmg: int) -> int:
	return dmg * 2 if randi_range(0, 1) == 0 else dmg


func _get_weakness_bonus(weakness: String) -> int:
	return 10 if weakness == "fire" else 0
