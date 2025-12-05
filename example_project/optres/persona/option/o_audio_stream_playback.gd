class_name OAudioStreamPlayback extends Option

static var __init_from_getter: bool

func _init() -> void:
	assert(
		__init_from_getter,
		"OAudioStreamPlayback cannot be manually instantiated."\
			+ " Use OAudioStreamPlayback.Some() or OAudioStreamPlayback.None()"\
			+ " to construct a new instance."
	)
	
static func _get_chained(current_chain_func: StringName) -> OAudioStreamPlayback:
	assert(Chain._store != null, "Chain.do() was not initialized with Chain.start().")
	assert(
		Chain._store is OAudioStreamPlayback,
		("%s expected a return value of type 'OAudioStreamPlayback' from previous chain method %s"\
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

static func None() -> OAudioStreamPlayback:
	__init_from_getter = true
	var opt: OAudioStreamPlayback = OAudioStreamPlayback.new()
	__init_from_getter = false
	return opt

static func Some(value: AudioStreamPlayback) -> OAudioStreamPlayback:
	__init_from_getter = true
	var opt: OAudioStreamPlayback = OAudioStreamPlayback.new()
	__init_from_getter = false
	opt._value = value
	return opt

func zip_with_to(other: Option, fn: Callable) -> OAudioStreamPlayback:
	if is_none() or other._value == null:
		return None()
	
	var a: Variant = fn.call(_value, other._value)
	assert(a is AudioStreamPlayback, "Expected a return value of type 'AudioStreamPlayback' from callback.")
	var b: AudioStreamPlayback = a
	return Some(b)
	
static func zip_with_to_c(other: Option, fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.zip_with_to_c()").zip_with_to(other, fn)
	return Chain._ChainArg.inst

func xor(optb: OAudioStreamPlayback) -> OAudioStreamPlayback:
	if is_some() and optb.is_none():
		var v: AudioStreamPlayback = _value
		return Some(v)
	if is_none() and optb.is_some():
		var v: AudioStreamPlayback = optb._value
		return Some(v)
	return None()
	
static func xor_c(optb: OAudioStreamPlayback) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.xor_c()").xor(optb)
	return Chain._ChainArg.inst

func unwrap() -> AudioStreamPlayback:
	assert(is_some(), "Tried to unwrap None as Some.")
	var v: AudioStreamPlayback = _value
	return v
	
static func unwrap_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.unwrap_c()").unwrap()
	return Chain._ChainArg.inst

func unwrap_or(default: AudioStreamPlayback) -> AudioStreamPlayback:
	if is_some():
		var v: AudioStreamPlayback = _value
		return v
	return default
	
static func unwrap_or_c(default: AudioStreamPlayback) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.unwrap_or_c()").unwrap_or(default)
	return Chain._ChainArg.inst

func unwrap_or_else(default_fn: Callable) -> AudioStreamPlayback:
	if is_some():
		var v: AudioStreamPlayback = _value
		return v
	var a: Variant = default_fn.call()
	assert(a is AudioStreamPlayback, "Expected a return value of type 'AudioStreamPlayback' from callback.")
	var b: AudioStreamPlayback = a
	return b
	
static func unwrap_or_else_c(default_fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.unwrap_or_else_c()").unwrap_or_else(default_fn)
	return Chain._ChainArg.inst

func take() -> OAudioStreamPlayback:
	if is_some():
		var v: AudioStreamPlayback = _value
		_value = null
		return Some(v)
	return None()
	
static func take_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.take_c()").take()
	return Chain._ChainArg.inst

func replace(value: AudioStreamPlayback) -> OAudioStreamPlayback:
	var old_value: Variant = _value
	_value = value
	if old_value != null:
		var v: AudioStreamPlayback = old_value
		return Some(v)
	return None()
	
static func replace_c(value: AudioStreamPlayback) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.replace_c()").replace(value)
	return Chain._ChainArg.inst

func oR(optb: OAudioStreamPlayback) -> OAudioStreamPlayback:
	if is_some():
		var v: AudioStreamPlayback = _value
		return Some(v)
	if optb.is_some():
		var v: AudioStreamPlayback = optb._value
		return Some(v)
	
	return None()
	
static func or_c(optb: OAudioStreamPlayback) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.or_c()").oR(optb)
	return Chain._ChainArg.inst

func or_else(optb_fn: Callable) -> OAudioStreamPlayback:
	if is_some():
		var v: AudioStreamPlayback = _value
		return Some(v)
	var a: Variant = optb_fn.call()
	assert(a is OAudioStreamPlayback, "Expected a return value of type 'OAudioStreamPlayback' from callback.")
	var b: OAudioStreamPlayback = a
	return b
	
static func or_else_c(optb_fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.or_else_c()").or_else(optb_fn)
	return Chain._ChainArg.inst

func ok_or(err: Variant) -> RAudioStreamPlayback:
	if is_some():
		var v: AudioStreamPlayback = _value
		return RAudioStreamPlayback.Ok(v)
	return RAudioStreamPlayback.Err(err)
	
static func ok_or_c(err: Variant) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.ok_or_c()").ok_or(err)
	return Chain._ChainArg.inst

func ok_or_else(err_fn: Callable) -> RAudioStreamPlayback:
	if is_some():
		var v: AudioStreamPlayback = _value
		return RAudioStreamPlayback.Ok(v)
	return RAudioStreamPlayback.Err(err_fn.call())
	
static func ok_or_else_c(err_fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.ok_or_else_c()").ok_or_else(err_fn)
	return Chain._ChainArg.inst

static func map_to(opt: Option, fn: Callable) -> OAudioStreamPlayback:
	if opt._value != null:
		var a: Variant = fn.call(opt._value)
		assert(a is AudioStreamPlayback, "Expected a return value of type 'AudioStreamPlayback' from callback.")
		var b: AudioStreamPlayback = a
		return Some(b)
	return None()

static func map_to_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = map_to(_get_chained_variant(&"OAudioStreamPlayback.map_to_c()"), fn)
	return Chain._ChainArg.inst

static func map_or_to(opt: Option, default: AudioStreamPlayback, fn: Callable) -> AudioStreamPlayback:
	if opt._value != null:
		var a: Variant = fn.call(opt._value)
		assert(a is AudioStreamPlayback, "Expected a return value of type 'AudioStreamPlayback' from callback.")
		var b: AudioStreamPlayback = a
		return b
	return default

static func map_or_to_c(default: AudioStreamPlayback, fn: Callable) -> Chain._ChainArg:
	Chain._store = map_or_to(_get_chained_variant(&"OAudioStreamPlayback.map_or_to_c()"), default, fn)
	return Chain._ChainArg.inst

static func map_or_else_to(opt: Option, default_fn: Callable, fn: Callable) -> AudioStreamPlayback:
	if opt._value != null:
		var a: Variant = fn.call(opt._value)
		assert(a is AudioStreamPlayback, "Expected a return value of type 'AudioStreamPlayback' from callback.")
		var b: AudioStreamPlayback = a
		return b
	var x: Variant = default_fn.call()
	assert(x is AudioStreamPlayback, "Expected a return value of type 'AudioStreamPlayback' from default callback.")
	var y: AudioStreamPlayback = x
	return y
	
	
static func map_or_else_to_c(default_fn: Callable, fn: Callable) -> Chain._ChainArg:
	Chain._store = map_or_else_to(_get_chained_variant(&"OAudioStreamPlayback.map_or_else_to_c()"), default_fn, fn)
	return Chain._ChainArg.inst

func inspect(fn: Callable) -> OAudioStreamPlayback:
	if is_some():
		var v: AudioStreamPlayback = _value
		fn.call(v)
	return self
	
static func inspect_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.inspect_c()").inspect(fn)
	return Chain._ChainArg.inst

func inspect_none(fn: Callable) -> OAudioStreamPlayback:
	if is_none():
		fn.call()
	return self
	
static func inspect_none_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.inspect_none_c()").inspect_none(fn)
	return Chain._ChainArg.inst

func insert(value: AudioStreamPlayback) -> AudioStreamPlayback:
	_value = value
	return value
	
static func insert_c(value: AudioStreamPlayback) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.insert_c()").insert(value)
	return Chain._ChainArg.inst

func get_or_insert_with(value_fn: Callable) -> AudioStreamPlayback:
	if is_some():
		var v: AudioStreamPlayback = _value
		return v
	var a: Variant = value_fn.call()
	assert(a is AudioStreamPlayback, "Expected a return value of type 'AudioStreamPlayback' from callback.")
	var b: AudioStreamPlayback = a
	_value = b
	return b
	
static func get_or_insert_with_c(value_fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.get_or_insert_with_c()").get_or_insert_with(value_fn)
	return Chain._ChainArg.inst

func get_or_insert(value: AudioStreamPlayback) -> AudioStreamPlayback:
	if is_some():
		var v: AudioStreamPlayback = _value
		return v
	_value = value
	return value
	
static func get_or_insert_c(value: AudioStreamPlayback) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.get_or_insert_c()").get_or_insert(value)
	return Chain._ChainArg.inst

func filter(fn: Callable) -> OAudioStreamPlayback:
	if is_none():
		return None()
	var a: Variant = fn.call(_value)
	assert(a is bool, "Expected a return value of type 'bool' from callback.")
	var b: bool = a
	if b:
		var v: AudioStreamPlayback = _value
		return Some(v)
	return None()

static func filter_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.filter_c()").filter(fn)
	return Chain._ChainArg.inst

func expect(msg: String = "") -> AudioStreamPlayback:
	assert(is_some(), msg)
	var v: AudioStreamPlayback = _value
	return v
	
static func expect_c(msg: String = "") -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.expect_c()").expect(msg)
	return Chain._ChainArg.inst

static func and_then_to(opt: Option, optb_fn: Callable) -> OAudioStreamPlayback:
	if opt._value == null:
		return None()
	
	var a: Variant = optb_fn.call(opt._value)
	assert(a is OAudioStreamPlayback, "Expected a return value of type 'OAudioStreamPlayback' from callback.")
	var b: OAudioStreamPlayback = a
	return b
	
static func and_then_to_c(optb_fn: Callable) -> Chain._ChainArg:
	Chain._store = and_then_to(_get_chained_variant(&"OAudioStreamPlayback.and_then_to_c()"), optb_fn)
	return Chain._ChainArg.inst

static func and_to(opt: Option, optb: OAudioStreamPlayback) -> OAudioStreamPlayback:
	if opt._value == null or optb.is_none():
		return None()
	
	var v: AudioStreamPlayback = optb._value
	return Some(v)
	
static func and_to_c(optb: OAudioStreamPlayback) -> Chain._ChainArg:
	Chain._store = and_to(_get_chained_variant(&"OAudioStreamPlayback.and_to_c()"), optb)
	return Chain._ChainArg.inst

func zip(other: Option) -> OArray:
	if is_some() and other._value != null:
		OArray.__init_from_getter = true
		var new_opt: OArray = OArray.new()
		OArray.__init_from_getter = false
		var a: AudioStreamPlayback = _value
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
	Chain._store = _get_chained(&"OAudioStreamPlayback.zip_c()").zip(other)
	return Chain._ChainArg.inst

const _SOME: int = 0
const _NONE: int = 1
static func _get_match_err(
	case: String,
	expected: StringName,
	ret_type_name: Variant
) -> String:
	return 'OAudioStreamPlayback.match.do() expected "%s" from case "%s" but received "%s".'\
		% [expected, case, ret_type_name]
static var _o_match_from: _OMatch = _OMatch.new()
static func match(
	opt0: OAudioStreamPlayback,
	opt1: OAudioStreamPlayback = null,
	opt2: OAudioStreamPlayback = null,
	opt3: OAudioStreamPlayback = null,
	opt4: OAudioStreamPlayback = null,
	opt5: OAudioStreamPlayback = null,
	opt6: OAudioStreamPlayback = null,
	opt7: OAudioStreamPlayback = null,
	opt8: OAudioStreamPlayback = null,
	opt9: OAudioStreamPlayback = null,
) -> _OMatch:
	var opts: Array[OAudioStreamPlayback] = [opt0]
	for o: OAudioStreamPlayback in [
		opt1, opt2, opt3, opt4, opt5, opt6, opt7, opt8, opt9,
	]:
		if o != null:
			opts.push_back(o)
		else:
			break
			
	return matchv(opts)
static func matchv(opts: Array[OAudioStreamPlayback]) -> _OMatch:
	return _o_match_from._configure(opts)
class _OMatch:
	var _opts: Array[OAudioStreamPlayback]
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
				"OAudioStreamPlayback.match.to() expects 'StringName' for native types i.e. &'Node2D'"\
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
					"OAudioStreamPlayback.match.do() default case cannot have args but found %s."\
						% c.get_argument_count()
				)
			else:
				assert(
					c_name.length() == _opts.size(),
					"OAudioStreamPlayback.match.do() case '%s' is matching %s Option(s) but %s Option(s) were provided."\
						% [c_name, c_name.length(), _opts.size()]
				)
			
			if is_default:
				var ret: Variant = c.call()
				
				if _expected_name.is_empty():
					return ret
					
				var ret_type_name: StringName = OptResInternal.get_variant_type_name(ret)
					
				assert(ret_type_name == _expected_name, OAudioStreamPlayback._get_match_err(
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
						"Invalid character '%s' in OAudioStreamPlayback.match.do() case '%s'."\
							% [s, c_name]
					)
					return null
			
			var some_indices_count: int = meaningful_indices.values().count(_SOME)
			
			assert(
				c.get_argument_count() == some_indices_count,
				("OAudioStreamPlayback.match.do() expected an arg count of %s for case '%s'"\
					+ " matching %s Some(s) but found %s.")\
					% [
						some_indices_count,
						c_name,
						some_indices_count,
						c.get_argument_count()
					]
			)
			
			var should_call: bool = true
			var args: Array[AudioStreamPlayback] = []
			
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
					
				assert(ret_type_name == _expected_name, OAudioStreamPlayback._get_match_err(
					c_name,
					_expected_name,
					ret_type_name,
				))
					
				return ret
					
		assert(false, "OAudioStreamPlayback.match.do() was non-exhaustive.")
		return null
	
	
	func _configure(opts: Array[OAudioStreamPlayback]) -> _OMatch:
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
	Chain._store = _get_chained(&"OAudioStreamPlayback.is_some_and_c()").is_some_and(fn)
	return Chain._ChainArg.inst

func is_some() -> bool:
	return _value != null
	
static func is_some_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.is_some_c()").is_some()
	return Chain._ChainArg.inst

func is_none_or(fn: Callable) -> bool:
	if is_none():
		return true
	var a: Variant = fn.call(_value)
	assert(a is bool, "Expected a return value of type 'bool' from callback.")
	var b: bool = a
	return b
	
static func is_none_or_c(fn: Callable) -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.is_none_or_c()").is_none_or(fn)
	return Chain._ChainArg.inst

func is_none() -> bool:
	return _value == null
	
static func is_none_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.is_none_c()").is_none()
	return Chain._ChainArg.inst

func expect_none(msg: String = "") -> void:
	assert(is_none(), msg)
	
static func expect_none_c(msg: String = "") -> Chain._ChainArg:
	_get_chained(&"OAudioStreamPlayback.expect_none_c()").expect_none(msg)
	Chain._store = null	
	return Chain._ChainArg.inst
	
func as_array() -> Array:
	return [_value] if is_some() else []

static func as_array_c() -> Chain._ChainArg:
	Chain._store = _get_chained(&"OAudioStreamPlayback.as_array_c()").as_array()
	return Chain._ChainArg.inst
