extends Node

func _ready() -> void:
	var might_be_int: Oint = Oint.Some(12) if randi_range(0, 1) == 0 else Oint.None()
	var might_be_int_2: Oint = Oint.Some(69) if randi_range(0, 1) == 0 else Oint.None() 
	var might_be_int_3: Oint = Oint.Some(3) if randi_range(0, 1) == 0 else Oint.None()
	
	var msg: String = Oint\
		.match(might_be_int, might_be_int_2, might_be_int_3)\
		.to(&"String").do(
			func ssn (a: int, b: int) -> String:
				return ("First value is %s, second is %s, and third is none.") % [a, b],
			func sns (a: int, c: int) -> String:
				return ("First value is %s, second is none, and third is %s.") % [a, c],
			func sss (a: int, b: int, c: int) -> String:
				return ("First value is %s, second is %s, and third is %s.") % [a, b, c],
			func __s (_c: int) -> String:
				return "At least third value was Some.",
			func () -> String:
				return "Option defaulted.",
		)
	
	print("Option match result:\n\t%s" % msg)
