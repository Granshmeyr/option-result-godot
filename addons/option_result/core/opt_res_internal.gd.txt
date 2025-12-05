class_name OptResInternal

func _init() -> void:
	assert(false, "OptResInternal cannot be instantiated.")

static var variant_type_check: Dictionary[StringName, Callable] = {
	&"bool": func(v: Variant) -> bool: return v is bool,
	&"int": func(v: Variant) -> bool: return v is int,
	&"float": func(v: Variant) -> bool: return v is float,
	&"String": func(v: Variant) -> bool: return v is String,
	&"Vector2": func(v: Variant) -> bool: return v is Vector2,
	&"Vector2i": func(v: Variant) -> bool: return v is Vector2i,
	&"Rect2": func(v: Variant) -> bool: return v is Rect2,
	&"Rect2i": func(v: Variant) -> bool: return v is Rect2i,
	&"Vector3": func(v: Variant) -> bool: return v is Vector3,
	&"Vector3i": func(v: Variant) -> bool: return v is Vector3i,
	&"Transform2D": func(v: Variant) -> bool: return v is Transform2D,
	&"Vector4": func(v: Variant) -> bool: return v is Vector4,
	&"Vector4i": func(v: Variant) -> bool: return v is Vector4i,
	&"Plane": func(v: Variant) -> bool: return v is Plane,
	&"Quaternion": func(v: Variant) -> bool: return v is Quaternion,
	&"AABB": func(v: Variant) -> bool: return v is AABB,
	&"Basis": func(v: Variant) -> bool: return v is Basis,
	&"Transform3D": func(v: Variant) -> bool: return v is Transform3D,
	&"Projection": func(v: Variant) -> bool: return v is Projection,
	&"Color": func(v: Variant) -> bool: return v is Color,
	&"StringName": func(v: Variant) -> bool: return v is StringName,
	&"NodePath": func(v: Variant) -> bool: return v is NodePath,
	&"RID": func(v: Variant) -> bool: return v is RID,
	&"Object": func(v: Variant) -> bool: return v is Object,
	&"Callable": func(v: Variant) -> bool: return v is Callable,
	&"Signal": func(v: Variant) -> bool: return v is Signal,
	&"Dictionary": func(v: Variant) -> bool: return v is Dictionary,
	&"Array": func(v: Variant) -> bool: return v is Array,
	&"PackedByteArray": func(v: Variant) -> bool: return v is PackedByteArray,
	&"PackedInt32Array": func(v: Variant) -> bool: return v is PackedInt32Array,
	&"PackedInt64Array": func(v: Variant) -> bool: return v is PackedInt64Array,
	&"PackedFloat32Array": func(v: Variant) -> bool: return v is PackedFloat32Array,
	&"PackedFloat64Array": func(v: Variant) -> bool: return v is PackedFloat64Array,
	&"PackedStringArray": func(v: Variant) -> bool: return v is PackedStringArray,
	&"PackedVector2Array": func(v: Variant) -> bool: return v is PackedVector2Array,
	&"PackedVector3Array": func(v: Variant) -> bool: return v is PackedVector3Array,
	&"PackedColorArray": func(v: Variant) -> bool: return v is PackedColorArray,
	&"PackedVector4Array": func(v: Variant) -> bool: return v is PackedVector4Array,
}

const VARIANT_TYPE_NAMES: Dictionary[int, StringName] = {
	TYPE_BOOL: &"bool",
	TYPE_INT: &"int",
	TYPE_FLOAT: &"float",
	TYPE_STRING: &"String",
	TYPE_VECTOR2: &"Vector2",
	TYPE_VECTOR2I: &"Vector2i",
	TYPE_RECT2: &"Rect2",
	TYPE_RECT2I: &"Rect2i",
	TYPE_VECTOR3: &"Vector3",
	TYPE_VECTOR3I: &"Vector3i",
	TYPE_TRANSFORM2D: &"Transform2D",
	TYPE_VECTOR4: &"Vector4",
	TYPE_VECTOR4I: &"Vector4i",
	TYPE_PLANE: &"Plane",
	TYPE_QUATERNION: &"Quaternion",
	TYPE_AABB: &"AABB",
	TYPE_BASIS: &"Basis",
	TYPE_TRANSFORM3D: &"Transform3D",
	TYPE_PROJECTION: &"Projection",
	TYPE_COLOR: &"Color",
	TYPE_STRING_NAME: &"StringName",
	TYPE_NODE_PATH: &"NodePath",
	TYPE_RID: &"RID",
	TYPE_OBJECT: &"Object",
	TYPE_CALLABLE: &"Callable",
	TYPE_SIGNAL: &"Signal",
	TYPE_DICTIONARY: &"Dictionary",
	TYPE_ARRAY: &"Array",
	TYPE_PACKED_BYTE_ARRAY: &"PackedByteArray",
	TYPE_PACKED_INT32_ARRAY: &"PackedInt32Array",
	TYPE_PACKED_INT64_ARRAY: &"PackedInt64Array",
	TYPE_PACKED_FLOAT32_ARRAY: &"PackedFloat32Array",
	TYPE_PACKED_FLOAT64_ARRAY: &"PackedFloat64Array",
	TYPE_PACKED_STRING_ARRAY: &"PackedStringArray",
	TYPE_PACKED_VECTOR2_ARRAY: &"PackedVector2Array",
	TYPE_PACKED_VECTOR3_ARRAY: &"PackedVector3Array",
	TYPE_PACKED_COLOR_ARRAY: &"PackedColorArray",
	TYPE_PACKED_VECTOR4_ARRAY: &"PackedVector4Array",
}

static func get_variant_type_name(thing: Variant) -> StringName:
	if thing == null:
		return &"Nil"
		
	var thing_type_name: StringName
	
	if typeof(thing) != TYPE_OBJECT:
		thing_type_name = VARIANT_TYPE_NAMES\
			.get(typeof(thing))
	else:
		var thing_o: Object = thing
		var thing_script: GDScript = thing_o.get_script()
		if thing_script == null:
			thing_type_name = thing_o.get_class()
		else:
			thing_type_name = thing_script.get_global_name()
	
	return thing_type_name
