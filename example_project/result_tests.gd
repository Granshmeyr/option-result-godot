extends Node

func _ready() -> void:
	_tests()
	
	print("Result tests passed.")
	

func _tests() -> void:
	var contains: Callable = func () -> void:
		assert(Rint.Ok(10).contains(10))
		assert(not Rint.Ok(10).contains(9))
		assert(not Rint.Err("FAIL").contains(10))
	contains.call()
	
	var contains_err: Callable = func () -> void:
		assert(Rint.Err("FAIL").contains_err("FAIL"))
		assert(not Rint.Err("FAIL").contains_err("abc"))
		assert(not Rint.Ok(10).contains_err("FAIL"))
	contains_err.call()

	var err: Callable = func () -> void:
		assert(Rint.Ok(10).err().is_none())
		assert(Rint.Err("FAIL").err().is_some())
		assert(Rint.Err("FAIL").err().unwrap() == "FAIL")
	err.call()

	var expect_err: Callable = func () -> void:
		assert(Rint.Err("FAIL").expect_err("Should not fail."))
	expect_err.call()

	var is_err: Callable = func () -> void:
		assert(Rint.Err("FAIL").is_err())
		assert(not Rint.Ok(10).is_err())
	is_err.call()

	var is_err_and: Callable = func () -> void:
		assert(Rint.Err("FAIL").is_err_and(func (v: Variant) -> bool: return v == "FAIL"))
		assert(not Rint.Err("FAIL").is_err_and(func (v: Variant) -> bool: return v == "abc"))
		assert(not Rint.Ok(123).is_err_and(func (v: Variant) -> bool: return v == "FAIL"))
	is_err_and.call()

	var is_ok: Callable = func () -> void:
		assert(Rint.Ok(10).is_ok())
		assert(not Rint.Err("FAIL").is_ok())
	is_ok.call()

	var is_ok_and: Callable = func () -> void:
		assert(Rint.Ok(10).is_ok_and(func (v: int) -> bool: return v == 10))
		assert(not Rint.Ok(10).is_ok_and(func (v: int) -> bool: return v == 3))
		assert(not Rint.Err("FAIL").is_ok_and(func (v: int) -> bool: return v == 3))
	is_ok_and.call()

	var unwrap_err: Callable = func () -> void:
		assert(Rint.Err("FAIL").unwrap_err() == "FAIL")
	unwrap_err.call()

	var zip: Callable = func () -> void:
		assert(Rint.Ok(12).zip(Rint.Ok(55)).is_ok())
		assert(Rint.Ok(12).zip(Rint.Ok(55)).unwrap() == [12, 55])
		assert(Rint.Ok(12).zip(Rint.Err("FAIL")).is_err())
		assert(Rint.Ok(12).zip(Rint.Err("FAIL")).unwrap_err() == "FAIL")
		assert(Rint.Err("FAIL").zip(Rint.Ok(12)).is_err())
	zip.call()

	var and_to: Callable = func () -> void:
		assert(RString.and_to(
			Rint.Ok(12),
			RString.Ok("Hello"),
		).unwrap() == "Hello")
		assert(Rint.and_to(
			RString.Ok("Hello"),
			Rint.Err("FAIL"),
		).unwrap_err() == "FAIL")
		assert(Rint.and_to(
			RString.Err("FAIL"),
			Rint.Err("FAIL2"),
		).unwrap_err() == "FAIL")
		assert(RString.and_to(
			Rint.Err("FAIL"),
			RString.Ok("Hello"),
		).unwrap_err() == "FAIL")
	and_to.call()

	var and_then: Callable = func () -> void:
		assert(RString.and_then_to(
			Rint.Ok(12),
			func (v: int) -> RString:
				return RString.Ok("%s" % v),
		).unwrap() == "12")
		assert(RString.and_then_to(
			Rint.Ok(12),
			func (_v: int) -> RString:
				return RString.Err("FAIL"),
		).unwrap_err() == "FAIL")
		assert(RString.and_then_to(
			Rint.Err("FAIL_1"),
			func (_v: int) -> RString:
				return RString.Err("FAIL_2"),
		).unwrap_err() == "FAIL_1")
	and_then.call()

	var expect: Callable = func () -> void:
		assert(Rint.Ok(12).expect("Should not fail.") == 12)
	expect.call()

	var inspect_err: Callable = func () -> void:
		var called_arr: Array[bool] = [false]
		Rint.Err("FAIL").inspect_err(func (_v: Variant) -> void: called_arr[0] = true)
		assert(called_arr[0])
		called_arr[0] = false
		Rint.Ok(12).inspect_err(func (_v: int) -> void : called_arr[0] = true)
		assert(not called_arr[0])
	inspect_err.call()
	
	var inspect: Callable = func () -> void:
		var called_arr: Array[bool] = [false]
		Rint.Ok(12).inspect(func (_v: int) -> void: called_arr[0] = true)
		assert(called_arr[0])
		called_arr[0] = false
		Rint.Err("FAIL").inspect(func (_v: Variant) -> void : called_arr[0] = true)
		assert(not called_arr[0])
	inspect.call()

	var map_err: Callable = func () -> void:
		assert(Rint.map_err_to(
			Rint.Err("FAIL"),
			func (v: String) -> int:
				return v.length(),
		).unwrap_err() == 4)
		assert(Rint.map_err_to(
			Rint.Ok(12),
			func (v: String) -> int:
				return v.length(),
		).unwrap() == 12)
	map_err.call()

	var map_or_else_to: Callable = func () -> void:
		assert(Rint.map_or_else_to(
			Rint.Err("FAIL"),
			func (e: String) -> int: return e.length(),
			func (v: int) -> int: return v * 2,
		) == 4)
		assert(Rint.map_or_else_to(
			Rint.Ok(12),
			func (e: String) -> int: return e.length(),
			func (v: int) -> int: return v * 2,
		) == 24)
	map_or_else_to.call() 
	
	var map_or_to: Callable = func () -> void:
		assert(Rint.map_or_to(
			Rint.Err("FAIL"),
			5,
			func (v: int) -> int: return v * 2,
		) == 5)
		assert(Rint.map_or_to(
			Rint.Ok(12),
			5,
			func (v: int) -> int: return v * 2,
		) == 24)
	map_or_to.call() 

	var map_to: Callable = func () -> void:
		assert(Rint.map_to(
			Rint.Ok(12),
			func (v: int) -> int:
				return v * 2,
		).unwrap() == 24)
		assert(Rint.map_to(
			Rint.Err("FAIL"),
			func (v: int) -> int:
				return v * 2,
		).unwrap_err() == "FAIL")
	map_to.call()

	var ok: Callable = func () -> void:
		assert(Rint.Ok(12).ok().unwrap() == 12)
		assert(Rint.Err("FAIL").ok().is_none())
	ok.call()

	var or_else: Callable = func () -> void:
		assert(
			Rint.Ok(12)\
				.or_else(func (v: String) -> Rint: return Rint.Ok(v.length()))\
				.unwrap() == 12,
		)
		assert(
			Rint.Err("FAIL")\
				.or_else(func (v: String) -> Rint: return Rint.Ok(v.length()))\
				.unwrap() == 4,
		)
	or_else.call()

	var oR: Callable = func () -> void:
		assert(Rint.Ok(12).oR(Rint.Ok(55)).unwrap() == 12)
		assert(Rint.Err("FAIL").oR(Rint.Ok(55)).unwrap() == 55)
		assert(Rint.Ok(12).oR(Rint.Err("FAIL")).unwrap() == 12)
		assert(Rint.Err("FAIL_1").oR(Rint.Err("FAIL_2")).unwrap_err() == "FAIL_2")
	oR.call()

	var unwrap_or_else: Callable = func () -> void:
		assert(Rint.Ok(12).unwrap_or_else(func (v: String) -> int: return v.length()) == 12)
		assert(Rint.Err("FAIL").unwrap_or_else(func (v: String) -> int: return v.length()) == 4)
	unwrap_or_else.call()

	var unwrap_or: Callable = func () -> void:
		assert(Rint.Ok(12).unwrap_or(55) == 12)
		assert(Rint.Err("FAIL").unwrap_or(55) == 55)
	unwrap_or.call()

	var unwrap: Callable = func () -> void:
		assert(Rint.Ok(12).unwrap() == 12)
	unwrap.call()

	
