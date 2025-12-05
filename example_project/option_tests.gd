extends Node


func _ready() -> void:
	_tests()
	
	print("Option tests passed.")


func _tests() -> void:
	var as_array: Callable = func () -> void:
		assert(Oint.Some(10).as_array() == [10])
		assert(Oint.None().as_array() == [])
	as_array.call()
	
	var expect_none: Callable = func () -> void:
		Oint.None().expect_none("Should not fail.")
	expect_none.call()
	
	var is_none: Callable = func () -> void:
		assert(not Oint.Some(10).is_none())
		assert(Oint.None().is_none())
	is_none.call()
	
	var is_none_or: Callable = func () -> void:
		assert(Oint.None().is_none_or(func(v: int) -> bool: return v > 5))
		assert(Oint.Some(10).is_none_or(func(v: int) -> bool: return v > 5))
		assert(not Oint.Some(2).is_none_or(func(v: int) -> bool: return v > 5))
	is_none_or.call()
	
	var is_some: Callable = func () -> void:
		assert(Oint.Some(10).is_some())
		assert(not Oint.None().is_some())
	is_some.call()

	var is_some_and: Callable = func () -> void:
		assert(Oint.Some(10).is_some_and(func (v: int) -> bool: return v > 5))
		assert(not Oint.Some(2).is_some_and(func (v: int) -> bool: return v > 5))
		assert(not Oint.None().is_some_and(func (v: int) -> bool: return v > 5))
	is_some_and.call()
	
	var zip: Callable = func () -> void:
		assert(Oint.Some(12).zip(
			OString.Some("Hello"),
		).unwrap() == [12, "Hello"])
		assert(Oint.Some(12).zip(
			OString.None(),
		).is_none())
		assert(Oint.None().zip(
			OString.Some("Hello"),
		).is_none())
	zip.call()
	
	var and_to: Callable = func () -> void:
		assert(Oint.and_to(
			OString.Some("Hello"),
			Oint.Some(12),
		).unwrap() == 12)
		assert(Oint.and_to(
			OString.Some("Hello"),
			Oint.None(),
		).is_none())
		assert(Oint.and_to(
			OString.None(),
			Oint.Some(12),
		).is_none())
		assert(Oint.and_to(
			OString.None(),
			Oint.None(),
		).is_none())
	and_to.call()
		
	var and_then_to: Callable = func () -> void:
		assert(OString.and_then_to(
			Oint.Some(12),
			func (v: int) -> OString:
				return OString.Some("Value is %s." % v),
		).unwrap() == "Value is 12.")
		assert(OString.and_then_to(
			Oint.Some(12),
			func (_v: int) -> OString:
				return OString.None(),
		).is_none())
		assert(OString.and_then_to(
			Oint.None(),
			func (_v: int) -> OString:
				return OString.Some("Hello"),
		).is_none())
	and_then_to.call()
	
	var expect: Callable = func () -> void:
		assert(Oint.Some(12).expect("Should not fail.") == 12)
	expect.call()
	
	var filter: Callable = func () -> void:
		assert(Oint.Some(12).filter(func (v: int) -> bool: return v % 2 == 0).is_some())
		assert(Oint.Some(33).filter(func (v: int) -> bool: return v % 2 == 0).is_none())
	filter.call()
	
	var get_or_insert: Callable = func () -> void:
		var o: Oint = Oint.None()
		var inserted: int = o.get_or_insert(5)
		assert(o.is_some())
		assert(inserted == 5)
		var inserted_2: int = o.get_or_insert(9)
		assert(inserted_2 == 5)
		assert(o.unwrap_or(0) == 5)
	get_or_insert.call()
	
	var get_or_insert_with: Callable = func () -> void:
		var o: Oint = Oint.None()
		var called_arr: Array[bool] = [false]
		var inserted: int = o.get_or_insert_with(
			func () -> int:
				called_arr[0] = true
				return 7,
		)
		assert(called_arr[0])
		assert(inserted == 7)
		called_arr[0] = false
		var inserted_2: int = o.get_or_insert_with(
			func () -> int:
				called_arr[0] = true
				return 9,
		)
		assert(not called_arr[0])
		assert(inserted_2 == 7)
	get_or_insert_with.call()
	
	var insert: Callable = func () -> void:
		var o: Oint = Oint.None()
		var prev: int = o.insert(3)
		assert(o.unwrap_or(0) == 3)
		assert(prev == 3)
		var old: int = o.insert(9)
		assert(o.unwrap_or(0) == 9)
		assert(old == 9)
	insert.call()
	
	var inspect: Callable = func () -> void:
		var called_arr: Array[bool] = [false]
		Oint.Some(12).inspect(func (_v: int) -> void: called_arr[0] = true)
		assert(called_arr[0])
		called_arr[0] = false
		Oint.None().inspect(func (_v: int) -> void: called_arr[0] = true)
		assert(not called_arr[0])
	inspect.call()
	
	var inspect_none: Callable = func () -> void:
		var called_arr: Array[bool] = [false]
		Oint.None().inspect_none(func () -> void: called_arr[0] = true)
		assert(called_arr[0])
		called_arr[0] = false
		Oint.Some(12).inspect_none(func () -> void: called_arr[0] = true)
		assert(not called_arr[0])
	inspect_none.call()
	
	var map_or_else_to: Callable = func () -> void:
		assert(OString.map_or_else_to(
			Oint.Some(3),
			func () -> String:
				return "No value.",
			func (v: int) -> String:
				return "Value: %s." % v,
		) == "Value: 3.")
		assert(OString.map_or_else_to(
			Oint.None(),
			func () -> String:
				return "No value.",
			func (v: int) -> String:
				return "Value: %s." % v,
		) == "No value.")
	map_or_else_to.call()
	
	var map_or_to: Callable = func () -> void:
		assert(OString.map_or_to(
			Oint.Some(12),
			"No value.",
			func (v: int) -> String: return "Value: %s." % v
		) == "Value: 12.")
		assert(OString.map_or_to(
			Oint.None(),
			"No value.",
			func (v: int) -> String: return "Value: %s." % v
		) == "No value.")
	map_or_to.call()
	
	var map_to: Callable = func () -> void:
		assert(OString.map_to(
			Oint.Some(12),
			func (v: int) -> String:
				return "Value is %s." % v,
		).unwrap() == "Value is 12.")
		assert(OString.map_to(
			Oint.None(),
			func (v: int) -> String:
				return "Value is %s." % v,
		).is_none())
	map_to.call()
	
	var ok_or_else: Callable = func () -> void:
		assert(Oint.Some(12).ok_or_else(
			func () -> Variant: return "FAILED",
		).unwrap() == 12)
		assert(Oint.None().ok_or_else(
			func () -> Variant: return "FAILED",
		).unwrap_err() == "FAILED")
	ok_or_else.call()
	
	var or_else: Callable = func () -> void:
		assert(Oint.Some(12).or_else(
			func () -> Oint:
				return Oint.Some(55),
		).unwrap() == 12)
		assert(Oint.None().or_else(
			func () -> Oint:
				return Oint.Some(55),
		).unwrap() == 55)
	or_else.call()
	
	var or_: Callable = func () -> void:
		assert(Oint.Some(12).oR(
			Oint.Some(55)
		).unwrap() == 12)
		assert(Oint.None().oR(
			Oint.Some(55)
		).unwrap() == 55)
	or_.call()
	
	var replace: Callable = func () -> void:
		var s: Oint = Oint.Some(12)
		var old: Oint = s.replace(88)
		assert(s.unwrap() == 88)
		assert(old.unwrap() == 12)
	replace.call()
	
	var take: Callable = func () -> void:
		var s: Oint = Oint.Some(12)
		var old: Oint = s.take()
		assert(s.is_none())
		assert(old.unwrap() == 12)
	take.call()
	
	var unwrap_or_else: Callable = func () -> void:
		assert(Oint.Some(12)\
			.unwrap_or_else(
				func () -> int:
					return 69,
			) == 12)
		assert(Oint.None()\
			.unwrap_or_else(
				func () -> int:
					return 69,
			) == 69)
	unwrap_or_else.call()
	
	var unwrap_or: Callable = func () -> void:
		assert(Oint.Some(12).unwrap_or(69) == 12)
		assert(Oint.None().unwrap_or(69) == 69)
	unwrap_or.call()
	
	var xor: Callable = func () -> void:
		assert(Oint.Some(12).xor(Oint.None()).unwrap() == 12)
		assert(Oint.None().xor(Oint.Some(12)).unwrap() == 12)
		assert(Oint.Some(12).xor(Oint.Some(12)).is_none())
		assert(Oint.None().xor(Oint.None()).is_none())
	xor.call()
	
	var zip_with: Callable = func () -> void:
		assert(Oint.Some(12).zip_with_to(OString.Some("Hello"),
			func (a: int, b: String) -> int:
				return a + b.length(),
		).unwrap() == 17)
		assert(Oint.None().zip_with_to(OString.Some("Hello"),
			func (a: int, b: String) -> int:
				return a + b.length(),
		).is_none())
		assert(Oint.Some(12).zip_with_to(OString.None(),
			func (a: int, b: String) -> int:
				return a + b.length(),
		).is_none())
	zip_with.call()
	
	
	
	

	
