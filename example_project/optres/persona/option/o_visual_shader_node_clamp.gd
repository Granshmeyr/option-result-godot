class_name OVisualShaderNodeClamp extends Option

static var __init_from_getter: bool

func _init() -> void:
	assert(
		__init_from_getter,
		"OVisualShaderNodeClamp cannot be manually instantiated."\
			+ " Use OVisualShaderNodeClamp.Some() or OVisualShaderNodeClamp.None()"\
			+ " to construct a new instance."
	)
	
static func _get_chained(current_chain_func: StringName) -> OVisualShaderNodeClamp:
	assert(Chain._store != null, "Chain.do() was not initialized with Chain.start().")
	assert(
		Chain._store is OVisualShaderNodeClamp,
		("%s expected a return value of type 'OVisualShaderNodeClamp' from previous chain method %s"\
			+ " but received '%s'.")\
			% [
				current_chain_func,
				Chain._prev_chain_func,
				OptResInternal.get_variant_type_name(Chain._store),
			]
	)
	Chain._prev_chain_func = current_chain_func
	return Chain._store
	
static func _get_chained_variant(current_chain_func: StringName) -> Option:
	assert(Chain._store != null, "Chain.do() was not initialized with Chain.start().")
	assert(
		Chain._store is Option,
		("%s expected a return value of type 'Option' from previous chain method %s"\
			+ " but received '%s'.")\
			% [
				current_chain_func,
				Chain._prev_chain_func,
				OptResInternal.get_variant_type_name(Chain._store),
			]
	)
	Chain._prev_chain_func = current_chain_func
	return Chain._store

static func None() -> OVisualShaderNodeClamp:
	__init_from_getter = true
	var opt: OVisualShaderNodeClamp = OVisualShaderNodeClamp.new()
	__init_from_getter = false
	return opt

static func Some(value: VisualShaderNodeClamp) -> OVisualShaderNodeClamp:
	__init_from_getter = true
	var opt: OVisualShaderNodeClamp = OVisualShaderNodeClamp.new()
	__init_from_getter = false
	opt._value = value
	return opt

func zip_with_to(other: Option, fn: Callable) -> OVisualShaderNodeClamp:
	if is_none() or other._value == null:
		return None()
	
	var a: Variant = fn.call(_value, other._value)
	assert(a is VisualShaderNodeClamp, "Expected a return value of type 'VisualShaderNodeClamp' from callback.")
	var b: VisualShaderNodeClamp = a
	return Some(b)
	
static func zip_with_to_c(other: Option, fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.zip_with_to_c()").zip_with_to(other, fn)
	return Chain._ChainArg.inst

func xor(optb: OVisualShaderNodeClamp) -> OVisualShaderNodeClamp:
	if is_some() and optb.is_none():
		var v: VisualShaderNodeClamp = _value
		return Some(v)
	if is_none() and optb.is_some():
		var v: VisualShaderNodeClamp = optb._value
		return Some(v)
	return None()
	
static func xor_c(optb: OVisualShaderNodeClamp) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.xor_c()").xor(optb)
	return Chain._ChainArg.inst

func unwrap() -> VisualShaderNodeClamp:
	assert(is_some(), "Tried to unwrap None as Some.")
	var v: VisualShaderNodeClamp = _value
	return v
	
static func unwrap_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.unwrap_c()").unwrap()
	return Chain._ChainArg.inst

func unwrap_or(default: VisualShaderNodeClamp) -> VisualShaderNodeClamp:
	if is_some():
		var v: VisualShaderNodeClamp = _value
		return v
	return default
	
static func unwrap_or_c(default: VisualShaderNodeClamp) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.unwrap_or_c()").unwrap_or(default)
	return Chain._ChainArg.inst

func unwrap_or_else(default_fn: Callable) -> VisualShaderNodeClamp:
	if is_some():
		var v: VisualShaderNodeClamp = _value
		return v
	var a: Variant = default_fn.call()
	assert(a is VisualShaderNodeClamp, "Expected a return value of type 'VisualShaderNodeClamp' from callback.")
	var b: VisualShaderNodeClamp = a
	return b
	
static func unwrap_or_else_c(default_fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.unwrap_or_else_c()").unwrap_or_else(default_fn)
	return Chain._ChainArg.inst

func take() -> OVisualShaderNodeClamp:
	if is_some():
		var v: VisualShaderNodeClamp = _value
		_value = null
		return Some(v)
	return None()
	
static func take_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.take_c()").take()
	return Chain._ChainArg.inst

func replace(value: VisualShaderNodeClamp) -> OVisualShaderNodeClamp:
	var old_value: Variant = _value
	_value = value
	if old_value != null:
		var v: VisualShaderNodeClamp = old_value
		return Some(v)
	return None()
	
static func replace_c(value: VisualShaderNodeClamp) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.replace_c()").replace(value)
	return Chain._ChainArg.inst

func oR(optb: OVisualShaderNodeClamp) -> OVisualShaderNodeClamp:
	if is_some():
		var v: VisualShaderNodeClamp = _value
		return Some(v)
	if optb.is_some():
		var v: VisualShaderNodeClamp = optb._value
		return Some(v)
	
	return None()
	
static func or_c(optb: OVisualShaderNodeClamp) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.or_c()").oR(optb)
	return Chain._ChainArg.inst

func or_else(optb_fn: Callable) -> OVisualShaderNodeClamp:
	if is_some():
		var v: VisualShaderNodeClamp = _value
		return Some(v)
	var a: Variant = optb_fn.call()
	assert(a is OVisualShaderNodeClamp, "Expected a return value of type 'OVisualShaderNodeClamp' from callback.")
	var b: OVisualShaderNodeClamp = a
	return b
	
static func or_else_c(optb_fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.or_else_c()").or_else(optb_fn)
	return Chain._ChainArg.inst

func ok_or(err: Variant) -> RVisualShaderNodeClamp:
	if is_some():
		var v: VisualShaderNodeClamp = _value
		return RVisualShaderNodeClamp.Ok(v)
	return RVisualShaderNodeClamp.Err(err)
	
static func ok_or_c(err: Variant) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.ok_or_c()").ok_or(err)
	return Chain._ChainArg.inst

func ok_or_else(err_fn: Callable) -> RVisualShaderNodeClamp:
	if is_some():
		var v: VisualShaderNodeClamp = _value
		return RVisualShaderNodeClamp.Ok(v)
	return RVisualShaderNodeClamp.Err(err_fn.call())
	
static func ok_or_else_c(err_fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.ok_or_else_c()").ok_or_else(err_fn)
	return Chain._ChainArg.inst

static func map_to(opt: Option, fn: Callable) -> OVisualShaderNodeClamp:
	if opt._value != null:
		var a: Variant = fn.call(opt._value)
		assert(a is VisualShaderNodeClamp, "Expected a return value of type 'VisualShaderNodeClamp' from callback.")
		var b: VisualShaderNodeClamp = a
		return Some(b)
	return None()

static func map_to_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = map_to(_get_chained_variant(&"OVisualShaderNodeClamp.map_to_c()"), fn)
	return Chain._ChainArg.inst

static func map_or_to(opt: Option, default: VisualShaderNodeClamp, fn: Callable) -> VisualShaderNodeClamp:
	if opt._value != null:
		var a: Variant = fn.call(opt._value)
		assert(a is VisualShaderNodeClamp, "Expected a return value of type 'VisualShaderNodeClamp' from callback.")
		var b: VisualShaderNodeClamp = a
		return b
	return default

static func map_or_to_c(default: VisualShaderNodeClamp, fn: Callable) -> Chain._ChainArg:
	Chain._store = map_or_to(_get_chained_variant(&"OVisualShaderNodeClamp.map_or_to_c()"), default, fn)
	return Chain._ChainArg.inst

static func map_or_else_to(opt: Option, default_fn: Callable, fn: Callable) -> VisualShaderNodeClamp:
	if opt._value != null:
		var a: Variant = fn.call(opt._value)
		assert(a is VisualShaderNodeClamp, "Expected a return value of type 'VisualShaderNodeClamp' from callback.")
		var b: VisualShaderNodeClamp = a
		return b
	var x: Variant = default_fn.call()
	assert(x is VisualShaderNodeClamp, "Expected a return value of type 'VisualShaderNodeClamp' from default callback.")
	var y: VisualShaderNodeClamp = x
	return y
	
	
static func map_or_else_to_c(default_fn: Callable, fn: Callable) -> Chain._ChainArg:
	Chain._store = map_or_else_to(_get_chained_variant(&"OVisualShaderNodeClamp.map_or_else_to_c()"), default_fn, fn)
	return Chain._ChainArg.inst

func inspect(fn: Callable) -> OVisualShaderNodeClamp:
	if is_some():
		var v: VisualShaderNodeClamp = _value
		fn.call(v)
	return self
	
static func inspect_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.inspect_c()").inspect(fn)
	return Chain._ChainArg.inst

func inspect_none(fn: Callable) -> OVisualShaderNodeClamp:
	if is_none():
		fn.call()
	return self
	
static func inspect_none_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.inspect_none_c()").inspect_none(fn)
	return Chain._ChainArg.inst

func insert(value: VisualShaderNodeClamp) -> VisualShaderNodeClamp:
	_value = value
	return value
	
static func insert_c(value: VisualShaderNodeClamp) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.insert_c()").insert(value)
	return Chain._ChainArg.inst

func get_or_insert_with(value_fn: Callable) -> VisualShaderNodeClamp:
	if is_some():
		var v: VisualShaderNodeClamp = _value
		return v
	var a: Variant = value_fn.call()
	assert(a is VisualShaderNodeClamp, "Expected a return value of type 'VisualShaderNodeClamp' from callback.")
	var b: VisualShaderNodeClamp = a
	_value = b
	return b
	
static func get_or_insert_with_c(value_fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.get_or_insert_with_c()").get_or_insert_with(value_fn)
	return Chain._ChainArg.inst

func get_or_insert(value: VisualShaderNodeClamp) -> VisualShaderNodeClamp:
	if is_some():
		var v: VisualShaderNodeClamp = _value
		return v
	_value = value
	return value
	
static func get_or_insert_c(value: VisualShaderNodeClamp) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.get_or_insert_c()").get_or_insert(value)
	return Chain._ChainArg.inst

func filter(fn: Callable) -> OVisualShaderNodeClamp:
	if is_none():
		return None()
	var a: Variant = fn.call(_value)
	assert(a is bool, "Expected a return value of type 'bool' from callback.")
	var b: bool = a
	if b:
		var v: VisualShaderNodeClamp = _value
		return Some(v)
	return None()

static func filter_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.filter_c()").filter(fn)
	return Chain._ChainArg.inst

func expect(msg: String = "") -> VisualShaderNodeClamp:
	assert(is_some(), msg)
	var v: VisualShaderNodeClamp = _value
	return v
	
static func expect_c(msg: String = "") -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.expect_c()").expect(msg)
	return Chain._ChainArg.inst

static func and_then_to(opt: Option, optb_fn: Callable) -> OVisualShaderNodeClamp:
	if opt._value == null:
		return None()
	
	var a: Variant = optb_fn.call(opt._value)
	assert(a is OVisualShaderNodeClamp, "Expected a return value of type 'OVisualShaderNodeClamp' from callback.")
	var b: OVisualShaderNodeClamp = a
	return b
	
static func and_then_to_c(optb_fn: Callable) -> Chain._ChainArg:
	Chain._store = and_then_to(_get_chained_variant(&"OVisualShaderNodeClamp.and_then_to_c()"), optb_fn)
	return Chain._ChainArg.inst

static func and_to(opt: Option, optb: OVisualShaderNodeClamp) -> OVisualShaderNodeClamp:
	if opt._value == null or optb.is_none():
		return None()
	
	var v: VisualShaderNodeClamp = optb._value
	return Some(v)
	
static func and_to_c(optb: OVisualShaderNodeClamp) -> Chain._ChainArg:
	Chain._store = and_to(_get_chained_variant(&"OVisualShaderNodeClamp.and_to_c()"), optb)
	return Chain._ChainArg.inst

func zip(other: Option) -> OArray:
	if is_some() and other._value != null:
		OArray.__init_from_getter = true
		var new_opt: OArray = OArray.new()
		OArray.__init_from_getter = false
		var a: VisualShaderNodeClamp = _value
		var b: Variant = other._value
		var value: Array = []
		
		value.push_back(a)
			
		if b is Array:
			var b_arr: Array = b
			value.append_array(b_arr)
		else:
			value.push_back(b)
			
		new_opt._value = value
		return new_opt
	return OArray.None()
	
static func zip_c(other: Option) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.zip_c()").zip(other)
	return Chain._ChainArg.inst

const _SOME: int = 0
const _NONE: int = 1
static func _get_match_err(
	case: String,
	expected: StringName,
	ret_type_name: Variant
) -> String:
	return 'OVisualShaderNodeClamp.match.do() expected "%s" from case "%s" but received "%s".'\
		% [expected, case, ret_type_name]
static var _o_match_from: _OMatch = _OMatch.new()
static func match(
	opt0: OVisualShaderNodeClamp,
	opt1: OVisualShaderNodeClamp = null,
	opt2: OVisualShaderNodeClamp = null,
	opt3: OVisualShaderNodeClamp = null,
	opt4: OVisualShaderNodeClamp = null,
	opt5: OVisualShaderNodeClamp = null,
	opt6: OVisualShaderNodeClamp = null,
	opt7: OVisualShaderNodeClamp = null,
	opt8: OVisualShaderNodeClamp = null,
	opt9: OVisualShaderNodeClamp = null,
) -> _OMatch:
	var opts: Array[OVisualShaderNodeClamp] = [opt0]
	for o: OVisualShaderNodeClamp in [
		opt1, opt2, opt3, opt4, opt5, opt6, opt7, opt8, opt9,
	]:
		if o != null:
			opts.push_back(o)
		else:
			break
			
	return matchv(opts)
static func matchv(opts: Array[OVisualShaderNodeClamp]) -> _OMatch:
	return _o_match_from._configure(opts)
class _OMatch:
	var _opts: Array[OVisualShaderNodeClamp]
	var _expected_name: StringName
	var _expected_is_built_in: bool
	
	func to(expected: Variant) -> _OMatch:
		if expected is StringName:
			_expected_is_built_in = OptResInternal.variant_type_check.has(expected)
			_expected_name = expected
		elif expected is GDScript:
			var s: GDScript = expected
			_expected_name = s.get_global_name()
		else:
			assert(
				false,
				"OVisualShaderNodeClamp.match.to() expects 'StringName' for native types i.e. &'Node2D'"\
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
					"OVisualShaderNodeClamp.match.do() default case cannot have args but found %s."\
						% c.get_argument_count()
				)
			else:
				assert(
					c_name.length() == _opts.size(),
					"OVisualShaderNodeClamp.match.do() case '%s' is matching %s Option(s) but %s Option(s) were provided."\
						% [c_name, c_name.length(), _opts.size()]
				)
			
			if is_default:
				var ret: Variant = c.call()
				
				if _expected_name.is_empty():
					return ret
					
				var ret_type_name: StringName = OptResInternal.get_variant_type_name(ret)
					
				assert(ret_type_name == _expected_name, OVisualShaderNodeClamp._get_match_err(
					"default",
					_expected_name,
					ret_type_name,
				))
					
				return ret
			
			var meaningful_indices: Dictionary[int, int] = {}
			
			for i: int in range(c_name.length()):
				var s: String = str(c_name)[i]
			
				if s == "s":
					meaningful_indices.set(i, _SOME)
				elif s == "n":
					meaningful_indices.set(i, _NONE)
				elif s == "_":
					continue
				else:
					assert(
						false,
						"Invalid character '%s' in OVisualShaderNodeClamp.match.do() case '%s'."\
							% [s, c_name]
					)
					return null
			
			var some_indices_count: int = meaningful_indices.values().count(_SOME)
			
			assert(
				c.get_argument_count() == some_indices_count,
				("OVisualShaderNodeClamp.match.do() expected an arg count of %s for case '%s'"\
					+ " matching %s Some(s) but found %s.")\
					% [
						some_indices_count,
						c_name,
						some_indices_count,
						c.get_argument_count()
					]
			)
			
			var should_call: bool = true
			var args: Array[VisualShaderNodeClamp] = []
			
			for i: int in meaningful_indices:
				var value: int = meaningful_indices.get(i)
				
				if value == _SOME:
					if not _opts[i].is_some():
						should_call = false
						break
					
					args.push_back(_opts[i]._value)
				elif value == _NONE:
					if not _opts[i].is_none():
						should_call = false
						break
			
			if should_call:
				var ret: Variant = c.callv(args)
				
				if _expected_name.is_empty():
					return ret
					
				var ret_type_name: StringName = OptResInternal.get_variant_type_name(ret)
					
				assert(ret_type_name == _expected_name, OVisualShaderNodeClamp._get_match_err(
					c_name,
					_expected_name,
					ret_type_name,
				))
					
				return ret
					
		assert(false, "OVisualShaderNodeClamp.match.do() was non-exhaustive.")
		return null
	
	
	func _configure(opts: Array[OVisualShaderNodeClamp]) -> _OMatch:
		_opts = opts
		return self

func is_some_and(fn: Callable) -> bool:
	if is_none():
		return false
	var a: Variant = fn.call(_value)
	assert(a is bool, "Expected a return value of type 'bool' from callback.")
	var b: bool = a
	return b
	
static func is_some_and_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.is_some_and_c()").is_some_and(fn)
	return Chain._ChainArg.inst

func is_some() -> bool:
	return _value != null
	
static func is_some_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.is_some_c()").is_some()
	return Chain._ChainArg.inst

func is_none_or(fn: Callable) -> bool:
	if is_none():
		return true
	var a: Variant = fn.call(_value)
	assert(a is bool, "Expected a return value of type 'bool' from callback.")
	var b: bool = a
	return b
	
static func is_none_or_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.is_none_or_c()").is_none_or(fn)
	return Chain._ChainArg.inst

func is_none() -> bool:
	return _value == null
	
static func is_none_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.is_none_c()").is_none()
	return Chain._ChainArg.inst

func expect_none(msg: String = "") -> void:
	assert(is_none(), msg)
	
static func expect_none_c(msg: String = "") -> Chain._ChainArg:
	_get_chained(&"OVisualShaderNodeClamp.expect_none_c()").expect_none(msg)
	Chain._store = null	
	return Chain._ChainArg.inst
	
func as_array() -> Array:
	return [_value] if is_some() else []

static func as_array_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"OVisualShaderNodeClamp.as_array_c()").as_array()
	return Chain._ChainArg.inst
