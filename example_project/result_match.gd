extends Node

func _ready() -> void:
	var should_be_int: Rint = Rint.Ok(12) if randi_range(0, 1) == 0 else Rint.Err("FAIL")
	var should_be_int_2: Rint = Rint.Ok(33) if randi_range(0, 1) == 0 else Rint.Err("FAILURE")
	
	var msg: String = Rint\
		.match(should_be_int, should_be_int_2)\
		.to(&"String").do(
			func oe (a: int, b_err: Variant) -> String:
				return "First is %s, second errored with %s." % [a, b_err],
			func eo (a_err: Variant, b: int) -> String:
				return "First errored with %s, second is %s." % [a_err, b],
			func ee (a_err: Variant, b_err: Variant) -> String:
				return "First errored with %s, second errored with %s." % [a_err, b_err],
			func () -> String:
				return "Result match defaulted.",
		)
	
	print("Result match result:\n\t%s" % msg)
	
