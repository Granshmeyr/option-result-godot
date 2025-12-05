class_name Unit extends RefCounted

static var instance: Unit:
	get:
		if __instance_do_not_access == null:
			__init_from_getter = true
			__instance_do_not_access = Unit.new()
		__init_from_getter = false
		return __instance_do_not_access
static var __instance_do_not_access: Unit
static var __init_from_getter: bool

func _init() -> void:
	assert(
		Unit.__init_from_getter,
		"Unit cannot be manually instantiated. Unit.instance should be used instead."
	)
