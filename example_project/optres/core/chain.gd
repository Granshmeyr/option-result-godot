class_name Chain

static var _store: Variant
@warning_ignore("unused_private_class_variable")
static var _prev_chain_func: StringName


func _init() -> void:
	assert(false, "Chain cannot be instantiated.")


static func start(value: Variant) -> Chain._ChainArg:
	assert(value != null, "Chain.start() value cannot be null.")
	_store = value
	_prev_chain_func = "Chain.start()"
	return Chain._ChainArg.inst


static func to(expected: Variant) -> _ChainTo:
	var expected_name: StringName 
	var expected_is_built_in: bool
	
	if expected is StringName:
		expected_name = expected
		expected_is_built_in = OptResInternal.variant_type_check.has(expected)
	elif expected is GDScript:
		var expected_script: GDScript = expected
		expected_name = expected_script.get_global_name()
	else:
		assert(
			false,
			"Chain.to() expects 'StringName' for native types i.e. &'Node2D'"\
				+ " or direct instance for custom types i.e. MyCustomClass."
		)
		
		
	if expected_is_built_in:
		var callable: Callable = OptResInternal.variant_type_check.get(expected)
		assert(callable.call(_store), _get_err(expected_name))
	else:
		assert(_store is Object, _get_err(expected_name))
		var store_o: Object = _store
		var store_script: Script = store_o.get_script()
		if store_script == null:
			assert(store_o.get_class() == expected_name, _get_err(expected_name))
		else:
			assert(store_script.get_global_name() == expected_name, _get_err(expected_name))
			
	return _ChainTo.inst
	
	
static func do(
	_arg0: _ChainArg = null,
	_arg1: _ChainArg = null,
	_arg2: _ChainArg = null,
	_arg3: _ChainArg = null,
	_arg4: _ChainArg = null,
	_arg5: _ChainArg = null,
	_arg6: _ChainArg = null,
	_arg7: _ChainArg = null,
	_arg8: _ChainArg = null,
	_arg9: _ChainArg = null,
	_arg10: _ChainArg = null,
	_arg11: _ChainArg = null,
	_arg12: _ChainArg = null,
	_arg13: _ChainArg = null,
	_arg14: _ChainArg = null,
	_arg15: _ChainArg = null,
	_arg16: _ChainArg = null,
	_arg17: _ChainArg = null,
	_arg18: _ChainArg = null,
	_arg19: _ChainArg = null,
) -> Variant:
	var v: Variant = _store
	_store = null
	return v
	

static func _get_err(expected: StringName) -> String:
	return "Chain.do() expected a final type of '%s' but ended as '%s'."\
		% [expected, OptResInternal.get_variant_type_name(_store)]


class _ChainArg:
	static var inst: _ChainArg:
		get:
			if __inst_do_not_access == null:
				__inst_do_not_access = _ChainArg.new()
			return __inst_do_not_access
	static var __inst_do_not_access: _ChainArg
	
	
class _ChainTo:
	static var inst: _ChainTo:
		get:
			if __inst_do_not_access == null:
				__inst_do_not_access = _ChainTo.new()
			return __inst_do_not_access
	static var __inst_do_not_access: _ChainTo
	
	func do(
		_arg0: _ChainArg = null,
		_arg1: _ChainArg = null,
		_arg2: _ChainArg = null,
		_arg3: _ChainArg = null,
		_arg4: _ChainArg = null,
		_arg5: _ChainArg = null,
		_arg6: _ChainArg = null,
		_arg7: _ChainArg = null,
		_arg8: _ChainArg = null,
		_arg9: _ChainArg = null,
		_arg10: _ChainArg = null,
		_arg11: _ChainArg = null,
		_arg12: _ChainArg = null,
		_arg13: _ChainArg = null,
		_arg14: _ChainArg = null,
		_arg15: _ChainArg = null,
		_arg16: _ChainArg = null,
		_arg17: _ChainArg = null,
		_arg18: _ChainArg = null,
		_arg19: _ChainArg = null,
	) -> Variant:
		return Chain.do()
