class_name RVisualShaderNodeTexture extends Result

static var __init_from_getter: bool

func _init() -> void:
	assert(
		__init_from_getter,
		"RVisualShaderNodeTexture cannot be manually instantiated."\
			+ " Use RVisualShaderNodeTexture.Some() or RVisualShaderNodeTexture.None()"\
			+ " to construct a new instance."
	)
	
static func _get_chained(current_chain_func: StringName) -> RVisualShaderNodeTexture:
	assert(Chain._store != null, "Chain.do() was not initialized with Chain.start().")
	assert(
		Chain._store is RVisualShaderNodeTexture,
		("%s expected a return value of type 'RVisualShaderNodeTexture' from previous chain method %s"\
			+ " but received '%s'.")\
			% [
				current_chain_func,
				Chain._prev_chain_func,
				OptResInternal.get_variant_type_name(Chain._store),
			]
	)
	Chain._prev_chain_func = current_chain_func
	return Chain._store
	
static func _get_chained_variant(current_chain_func: StringName) -> Result:
	assert(Chain._store != null, "Chain.do() was not initialized with Chain.start().")
	assert(
		Chain._store is Result,
		("%s expected a return value of type 'Result' from previous chain method %s"\
			+ " but received '%s'.")\
			% [
				current_chain_func,
				Chain._prev_chain_func,
				OptResInternal.get_variant_type_name(Chain._store),
			]
	)
	Chain._prev_chain_func = current_chain_func
	return Chain._store
	
static func Ok(value: VisualShaderNodeTexture) -> RVisualShaderNodeTexture:
	__init_from_getter = true
	var res: RVisualShaderNodeTexture = RVisualShaderNodeTexture.new()
	__init_from_getter = false
	res._ok = value
	return res
	
static func Err(value: Variant) -> RVisualShaderNodeTexture:
	__init_from_getter = true
	var res: RVisualShaderNodeTexture = RVisualShaderNodeTexture.new()
	__init_from_getter = false
	res._err = value
	return res
	
func contains(value: Variant) -> bool:
	if is_err():
		return false
	return _ok == value
	
static func contains_c(value: Variant) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.contains_c()").contains(value)
	return Chain._ChainArg.inst
	
func contains_err(value: Variant) -> bool:
	if is_ok():
		return false
	return _err == value
	
static func contains_err_c(value: Variant) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.contains_err_c()").contains_err(value)
	return Chain._ChainArg.inst
	
func err() -> OVariant:
	if is_err():
		return OVariant.Some(_err)
	return OVariant.None()
	
static func err_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.err_c()").err()
	return Chain._ChainArg.inst
	
func expect_err(msg: String = "") -> Variant:
	assert(is_err(), msg)
	return _err
	
static func expect_err_c(msg: String = "") -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.expect_err_c()").expect_err(msg)
	return Chain._ChainArg.inst
	
func is_err() -> bool:
	return _err != null
	
static func is_err_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.is_err_c()").is_err()
	return Chain._ChainArg.inst
	
func is_err_and(fn: Callable) -> bool:
	if is_ok():
		return false
	
	var a: Variant = fn.call(_err)
	assert(a is bool, "Expected a return value of type 'bool' from callback.")
	var b: bool = a
	return b
	
static func is_err_and_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.is_err_and_c()").is_err_and(fn)
	return Chain._ChainArg.inst
	
func is_ok() -> bool:
	return _ok != null
	
static func is_ok_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.is_ok_c()").is_ok()
	return Chain._ChainArg.inst
	
func is_ok_and(fn: Callable) -> bool:
	if is_err():
		return false
		
	var a: Variant = fn.call(_ok)
	assert(a is bool, "Expected a return value of type 'bool' from callback.")
	var b: bool = a
	return b
	
static func is_ok_and_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.is_ok_and_c()").is_ok_and(fn)
	return Chain._ChainArg.inst
	
const _OK: int = 0
const _ERR: int = 1
static func _get_match_err(
	case: String,
	expected: StringName,
	ret_type_name: Variant
) -> String:
	return "RVisualShaderNodeTexture.match.do() expected '%s' from case '%s' but received '%s'."\
		% [expected, case, ret_type_name]
static var _r_match_from: _RMatch = _RMatch.new()
static func match(
	res0: RVisualShaderNodeTexture,
	res1: RVisualShaderNodeTexture = null,
	res2: RVisualShaderNodeTexture = null,
	res3: RVisualShaderNodeTexture = null,
	res4: RVisualShaderNodeTexture = null,
	res5: RVisualShaderNodeTexture = null,
	res6: RVisualShaderNodeTexture = null,
	res7: RVisualShaderNodeTexture = null,
	res8: RVisualShaderNodeTexture = null,
	res9: RVisualShaderNodeTexture = null,
) -> _RMatch:
	var resv: Array[RVisualShaderNodeTexture] = [res0]
	for r: RVisualShaderNodeTexture in [
		res1, res2, res3, res4, res5, res6, res7, res8, res9,
	]:
		if r != null:
			resv.push_back(r)
		else:
			break
			
	return matchv(resv)
static func matchv(resv: Array[RVisualShaderNodeTexture]) -> _RMatch:
	return _r_match_from._configure(resv)
class _RMatch:
	var _resv: Array[RVisualShaderNodeTexture]
	var _expected_name: StringName
	var _expected_is_built_in: bool
	
	func to(expected: Variant) -> _RMatch:
		if expected is StringName:
			_expected_is_built_in = OptResInternal.variant_type_check.has(expected)
			_expected_name = expected
		elif expected is GDScript:
			var s: GDScript = expected
			_expected_name = s.get_global_name()
		else:
			assert(
				false,
				"RVisualShaderNodeTexture.match.to() expects 'StringName' for native types i.e. &'Node2D'"\
				+ " or direct instance for custom types i.e. MyCustomClass."
			)
		return self
	
	func do(
		case0: Callable,
		case1: Callable = Callable(),
		case2: Callable = Callable(),
		case3: Callable = Callable(),
		case4: Callable = Callable(),
		case5: Callable = Callable(),
		case6: Callable = Callable(),
		case7: Callable = Callable(),
		case8: Callable = Callable(),
		case9: Callable = Callable(),
		case10: Callable = Callable(),
		case11: Callable = Callable(),
		case12: Callable = Callable(),
		case13: Callable = Callable(),
		case14: Callable = Callable(),
		case15: Callable = Callable(),
		case16: Callable = Callable(),
		case17: Callable = Callable(),
		case18: Callable = Callable(),
		case19: Callable = Callable(),
	) -> Variant:
		var cases: Array[Callable] = []
		
		for c: Callable in [case0, case1, case2, case3, case4, case5, case6, case7, case8, case9, case10, case11, case12, case13, case14, case15, case16, case17, case18, case19]:
			if not c.is_null():
				cases.push_back(c)
			else:
				break
		
		return dov(cases)
	
	func dov(cases: Array[Callable]) -> Variant:
		for c: Callable in cases:
			if c.is_null():
				continue
				
			var c_name: StringName = c.get_method()
			var is_default: bool = c_name == "<anonymous lambda>"
			
			if is_default:
				assert(
					c.get_argument_count() == 0,
					"RVisualShaderNodeTexture.match.do() default case cannot have args but found %s."\
						% c.get_argument_count()
				)
			else:
				assert(
					c_name.length() == _resv.size(),
					"RVisualShaderNodeTexture.match.do() case '%s' is matching %s Result(s) but %s Result(s) were provided."\
						% [c_name, c_name.length(), _resv.size()]
				)
			
			if is_default:
				var ret: Variant = c.call()
				
				if _expected_name.is_empty():
					return ret
					
				var ret_type_name: StringName = OptResInternal.get_variant_type_name(ret)
					
				assert(ret_type_name == _expected_name, RVisualShaderNodeTexture._get_match_err(
					"default",
					_expected_name,
					ret_type_name,
				))
					
				return ret
			
			var meaningful_indices: Dictionary[int, int] = {}
			
			for i: int in range(c_name.length()):
				var s: String = str(c_name)[i]
			
				if s == "o":
					meaningful_indices.set(i, _OK)
				elif s == "e":
					meaningful_indices.set(i, _ERR)
				elif s == "_":
					continue
				else:
					assert(
						false,
						"Invalid character '%s' in RVisualShaderNodeTexture.match.do() case '%s'."\
							% [s, c_name]
					)
					return null
			
			var ok_indices_count: int = meaningful_indices.values().count(_OK)
			var err_indices_count: int = meaningful_indices.values().count(_ERR)
			
			assert(
				c.get_argument_count() == ok_indices_count + err_indices_count,
				("RVisualShaderNodeTexture.match.do() expected an arg count of %s for case '%s'"\
					+ " matching %s Ok(s) + Err(s) but found %s.")\
					% [
						ok_indices_count + err_indices_count,
						c_name,
						ok_indices_count + err_indices_count,
						c.get_argument_count()
					]
			)
			
			var should_call: bool = true
			var args: Array[Variant] = []
			
			for i: int in meaningful_indices:
				var value: int = meaningful_indices.get(i)
				
				if value == _OK:
					if not _resv[i].is_ok():
						should_call = false
						break
					
					args.push_back(_resv[i]._ok)
				elif value == _ERR:
					if not _resv[i].is_err():
						should_call = false
						break
						
					args.push_back(_resv[i]._err)
			
			if should_call:
				var ret: Variant = c.callv(args)
				
				if _expected_name.is_empty():
					return ret
					
				var ret_type_name: StringName = OptResInternal.get_variant_type_name(ret)
					
				assert(ret_type_name == _expected_name, RVisualShaderNodeTexture._get_match_err(
					c_name,
					_expected_name,
					ret_type_name,
				))
					
				return ret
					
		assert(false, "RVisualShaderNodeTexture.match.do() was non-exhaustive.")
		return null
	
	
	func _configure(resv: Array[RVisualShaderNodeTexture]) -> _RMatch:
		_resv = resv
		return self
		
func unwrap_err() -> Variant:
	assert(is_err(), "Tried to unwrap Ok as Err.")
	return _err
	
static func unwrap_err_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.unwrap_err_c()").unwrap_err()
	return Chain._ChainArg.inst
	
func zip(other: Result) -> RArray:
	if is_ok() and other._ok != null:
		RArray.__init_from_getter = true
		var new_res: RArray = RArray.new()
		RArray.__init_from_getter = false
		var a: VisualShaderNodeTexture = _ok
		var b: Variant = other._ok
		var ok_value: Array = []
		
		ok_value.push_back(a)
			
		if b is Array:
			var b_arr: Array = b
			ok_value.append_array(b_arr)
		else:
			ok_value.push_back(b)
		
		new_res._ok = ok_value
		return new_res
		
	if is_err():
		return RArray.Err(_err)
	if other._err != null:
		return RArray.Err(other._err)
	
	return null
	
func zip_c(other: Result) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.zip_c()").zip(other)
	return Chain._ChainArg.inst
	
static func and_to(res: Result, resb: RVisualShaderNodeTexture) -> RVisualShaderNodeTexture:
	if res._ok != null:
		return resb
	return RVisualShaderNodeTexture.Err(res._err)
	
static func and_to_c(resb: RVisualShaderNodeTexture) -> Chain._ChainArg:
	Chain._store = and_to(_get_chained_variant(&"RVisualShaderNodeTexture.and_to_c()"), resb)
	return Chain._ChainArg.inst
	
static func and_then_to(res: Result, fn: Callable) -> RVisualShaderNodeTexture:
	if res._err != null:
		return RVisualShaderNodeTexture.Err(res._err)
	var a: Variant = fn.call(res._ok)
	assert(a is RVisualShaderNodeTexture, "Expected a return value of type 'RVisualShaderNodeTexture' from callback.")
	var b: RVisualShaderNodeTexture = a
	return b
	
static func and_then_to_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = and_then_to(_get_chained_variant(&"RVisualShaderNodeTexture.and_then_to_c()"), fn)
	return Chain._ChainArg.inst
	
func expect(msg: String = "") -> VisualShaderNodeTexture:
	assert(is_ok(), msg)
	return _ok
	
static func expect_c(msg: String = "") -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.expect_c()").expect(msg)
	return Chain._ChainArg.inst
	
func inspect_err(fn: Callable) -> RVisualShaderNodeTexture:
	if is_err():
		fn.call(_err)
	return self
	
static func inspect_err_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.inspect_err_c()").inspect_err(fn)
	return Chain._ChainArg.inst
	
func inspect(fn: Callable) -> RVisualShaderNodeTexture:
	if is_ok():
		fn.call(_ok)
	return self
	
static func inspect_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.inspect_c()").inspect(fn)
	return Chain._ChainArg.inst
	
static func map_err_to(res: Result, fn: Callable) -> RVisualShaderNodeTexture:
	if res._err != null:
		return RVisualShaderNodeTexture.Err(fn.call(res._err))
	var v: VisualShaderNodeTexture = res._ok
	return RVisualShaderNodeTexture.Ok(v)
	
static func map_err_to_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = map_err_to(_get_chained_variant(&"RVisualShaderNodeTexture.map_err_to_c()"), fn)
	return Chain._ChainArg.inst
	
static func map_or_else_to(res: Result, default_fn: Callable, fn: Callable) -> VisualShaderNodeTexture:
	if res._err != null:
		var a: Variant = default_fn.call(res._err)
		assert(a is VisualShaderNodeTexture, "Expected a return value of type 'VisualShaderNodeTexture' from default callback.")
		var b: VisualShaderNodeTexture = a
		return b
	var x: Variant = fn.call(res._ok)
	assert(x is VisualShaderNodeTexture, "Expected a return value of type 'VisualShaderNodeTexture' from callback.")
	var y: VisualShaderNodeTexture = x
	return y
	
static func map_or_else_to_c(default_fn: Callable, fn: Callable) -> Chain._ChainArg:
	Chain._store = map_or_else_to(_get_chained_variant(&"RVisualShaderNodeTexture.map_or_else_to_c()"), default_fn, fn)
	return Chain._ChainArg.inst
	
static func map_or_to(res: Result, default: VisualShaderNodeTexture, fn: Callable) -> VisualShaderNodeTexture:
	if res._err != null:
		return default
	var a: Variant = fn.call(res._ok)
	assert(a is VisualShaderNodeTexture, "Expected a return value of type 'VisualShaderNodeTexture' from callback.")
	var b: VisualShaderNodeTexture = a
	return b
	
static func map_or_to_c(default: VisualShaderNodeTexture, fn: Callable) -> Chain._ChainArg:
	Chain._store = map_or_to(_get_chained_variant(&"RVisualShaderNodeTexture.map_or_to_c()"), default, fn)
	return Chain._ChainArg.inst
	
static func map_to(res: Result, fn: Callable) -> RVisualShaderNodeTexture:
	if res._ok != null:
		var a: Variant = fn.call(res._ok)
		assert(a is VisualShaderNodeTexture, "Expected a return value of type 'VisualShaderNodeTexture' from callback.")
		var b: VisualShaderNodeTexture = a
		return RVisualShaderNodeTexture.Ok(b)
	return RVisualShaderNodeTexture.Err(res._err)
	
static func map_to_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = map_to(_get_chained_variant(&"RVisualShaderNodeTexture.map_to_c()"), fn)
	return Chain._ChainArg.inst
	
func ok() -> OVisualShaderNodeTexture:
	if is_ok():
		var v: VisualShaderNodeTexture = _ok
		return OVisualShaderNodeTexture.Some(v)
	return OVisualShaderNodeTexture.None()
	
static func ok_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.ok_c()").ok()
	return Chain._ChainArg.inst
	
func or_else(resb_fn: Callable) -> RVisualShaderNodeTexture:
	if is_err():
		var a: Variant = resb_fn.call(_err)
		assert(a is RVisualShaderNodeTexture, "Expected a return value of type 'RVisualShaderNodeTexture' from callback.")
		var b: RVisualShaderNodeTexture = a
		return b
	var v: VisualShaderNodeTexture = _ok
	return RVisualShaderNodeTexture.Ok(v)
	
static func or_else_c(resb_fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.or_else_c()").or_else(resb_fn)
	return Chain._ChainArg.inst
	
func oR(resb: RVisualShaderNodeTexture) -> RVisualShaderNodeTexture:
	if is_err():
		return resb
	var v: VisualShaderNodeTexture = _ok
	return RVisualShaderNodeTexture.Ok(v)
	
static func or_c(resb: RVisualShaderNodeTexture) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.or_c()").oR(resb)
	return Chain._ChainArg.inst
	
func unwrap_or_else(fn: Callable) -> VisualShaderNodeTexture:
	if is_ok():
		return _ok
	var a: Variant = fn.call(_err)
	assert(a is VisualShaderNodeTexture, "Expected a return value of type 'VisualShaderNodeTexture' from callback.")
	var b: VisualShaderNodeTexture = a
	return b
	
static func unwrap_or_else_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.unwrap_or_else_c()").unwrap_or_else(fn)
	return Chain._ChainArg.inst
	
func unwrap_or(default: VisualShaderNodeTexture) -> VisualShaderNodeTexture:
	if is_ok():
		return _ok
	return default
	
static func unwrap_or_c(default: VisualShaderNodeTexture) -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.unwrap_or_c()").unwrap_or(default)
	return Chain._ChainArg.inst
	
func unwrap() -> VisualShaderNodeTexture:
	assert(is_ok(), "Tried to unwrap Err as Ok.")
	return _ok
	
static func unwrap_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"RVisualShaderNodeTexture.unwrap_c()").unwrap()
	return Chain._ChainArg.inst
