@tool
extends EditorPlugin

static var _GrindleCodeGen: GDScript:
	get:
		return load("%s/grindle_code_gen_embed.gd" % _PATH_ADDON)

# symbols
const _TMP: String = "tmp"
const _TXT: String = "txt"
const _GD: String = "gd"
const _N: String = "\n"
const _T: String = "\t"

const _PATH_ROOT: String = "res:/"
const _PATH_ADDON: String = "%s/addons/option_result" % _PATH_ROOT
const _PATH_GEN: String = "%s/optres" % _PATH_ROOT
const _FOLDER_CORE: String = "core"
const _FOLDER_PERSONA: String = "persona"
const _FOLDER_OPTION: String = "option"
const _FOLDER_RESULT: String = "result"
const _FILE_PERSONA_TEMPLATE: String = "persona_template"
const _ALL_CORE_FILES: PackedStringArray = [
	"chain",
	"opt_res_internal",
	"option",
	"result",
	"unit",
	"o_array",
	"o_unit",
	"o_variant",
	"r_array",
	"r_unit",
	"r_variant",
]
const _CUSTOM_CORE_CLASS_NAMES: PackedStringArray = [
	"Chain",
	"OptResInternal",
	"Option",
	"Result",
	"Unit",
]
const _PRE_GENERATED_PERSONA_BASES: PackedStringArray = [
	"Array",
	"Unit",
	"Variant",
]

# templates



func _enter_tree() -> void:
	var popup_menu: PopupMenu = PopupMenu.new()
	
	popup_menu.add_item("Create Core Files (%s/%s/*)" % [_PATH_GEN, _FOLDER_CORE], 0)
	popup_menu.add_item("Generate Personas (%s/%s/*)" % [_PATH_GEN, _FOLDER_PERSONA], 1)
	popup_menu.id_pressed.connect(
		func(id: int) -> void:
			if id == 0:
				if _core_files_are_generated():
					print("%s Cannot overwrite core files, skipping..." % _get_log_prefix())
					
					return
				
				var tmp_core_files: PackedStringArray = _generate_missing_tmp_core_files()
				
				for f: String in tmp_core_files:
					DirAccess.rename_absolute(f, f.trim_suffix(".%s" % _TMP))
					
				EditorInterface.get_resource_filesystem().scan()
			elif id == 1:
				_on_generate_static_typing()
	)
	
	add_tool_submenu_item("Option<T> & Result<T>", popup_menu)
	
	
func _exit_tree() -> void:
	remove_tool_menu_item("Option<T> & Result<T>")


func _on_generate_static_typing() -> void:
	var engine_class_list: PackedStringArray = ClassDB.get_class_list()
	var all_project_class_names: PackedStringArray = ProjectSettings\
		.get_global_class_list()\
		.map(
			func (v: Dictionary) -> StringName:
				return v.get("class"),
		)
	var filtered_class_names: PackedStringArray = ((
		_ALL_VARIANT_CLASS_NAMES
		+ _ALL_BUILT_IN_OBJECT_CLASS_NAMES
		+ all_project_class_names
	) as Array[String]).filter(func (class_name_str: StringName) -> bool:
		if (_CUSTOM_CORE_CLASS_NAMES.has(class_name_str)
			or _PRE_GENERATED_PERSONA_BASES.has(class_name_str)
		):
			return false
		
		if class_name_str.begins_with("O") or class_name_str.begins_with("R"):
			var stripped_name: String = class_name_str.erase(0)
			
			if (
				_PRE_GENERATED_PERSONA_BASES.has(stripped_name) or
				_ALL_VARIANT_CLASS_NAMES.has(stripped_name) or
				engine_class_list.has(stripped_name)
			):
				return false
		
		return true
	)
	var option_class_names: PackedStringArray = filtered_class_names
	var result_class_names: PackedStringArray = filtered_class_names
		
	# verify core files are copied
	
	if not _core_files_are_generated():
		printerr("%s Core files must be created first." % _get_log_prefix())
		
		return
	
		
	# generation
	
	# gen type files
	
	var new_option_persona_tmp_files: PackedStringArray = _create_persona_tmp_files(
		"%s/%s/%s" % [_PATH_GEN, _FOLDER_PERSONA, _FOLDER_OPTION],
		"o_",
		"",
		FileAccess.get_file_as_string("%s/%s/%s/%s.%s" % [
			_PATH_ADDON,
			_FOLDER_PERSONA,
			_FOLDER_OPTION,
			_FILE_PERSONA_TEMPLATE,
			_TXT,
		]),
		option_class_names,
	)
	var new_result_persona_tmp_files: PackedStringArray = _create_persona_tmp_files(
		"%s/%s/%s" % [_PATH_GEN, _FOLDER_PERSONA, _FOLDER_RESULT],
		"r_",
		"",
		FileAccess.get_file_as_string("%s/%s/%s/%s.%s" % [
			_PATH_ADDON,
			_FOLDER_PERSONA,
			_FOLDER_RESULT,
			_FILE_PERSONA_TEMPLATE,
			_TXT,
		]),
		result_class_names,
	)
	
	# gen dangling files overwrites
		
	var dangling_option_persona_files: PackedStringArray = _get_dangling_persona_files(
		"%s/%s/%s" % [_PATH_GEN, _FOLDER_PERSONA, _FOLDER_OPTION],
		"o_",
		option_class_names
	)
	var dangling_result_persona_files: PackedStringArray = _get_dangling_persona_files(
		"%s/%s/%s" % [_PATH_GEN, _FOLDER_PERSONA, _FOLDER_RESULT],
		"r_",
		result_class_names
	)
	
	var cleared_dangling_option_persona_tmp_files: PackedStringArray = []
	var cleared_dangling_result_persona_tmp_files: PackedStringArray = []
	
	for a: Array in [
		[
			dangling_option_persona_files,
			func(v: String) -> void:
				cleared_dangling_option_persona_tmp_files.push_back(v),
		],
		[
			dangling_result_persona_files,
			func(v: String) -> void:
				cleared_dangling_result_persona_tmp_files.push_back(v),
		],
	]:
		var arr: PackedStringArray = a[0]
		var pusher: Callable = a[1]
		
		for f: String in arr:
			var f_tmp: String = "%s.%s" % [f, _TMP]
			var f_fa: FileAccess = FileAccess.open(f_tmp, FileAccess.WRITE)
			
			if f_fa:
				f_fa.store_string("pass")
				f_fa.close()
			
			pusher.call(f_tmp)
	
	# write .tmp files to original
	
	var all_tmp_files: PackedStringArray = []
	
	all_tmp_files = all_tmp_files\
		+ new_option_persona_tmp_files\
		+ new_result_persona_tmp_files\
		+ cleared_dangling_option_persona_tmp_files\
		+ cleared_dangling_result_persona_tmp_files
	
	for f: String in all_tmp_files:
		DirAccess.rename_absolute(f, f.trim_suffix(".%s" % _TMP))

	var fs: EditorFileSystem = EditorInterface.get_resource_filesystem()

	fs.scan()
	
	
func _create_persona_tmp_files(
	path: String,
	file_prefix: String,
	file_suffix: String,
	template: String,
	class_names: PackedStringArray,
	code_gen_opt: Dictionary[String, Variant] = {},
) -> PackedStringArray:
	var new_files: PackedStringArray = []
	
	DirAccess.make_dir_recursive_absolute(path)
	
	for i: int in range(class_names.size()):
		var n: String = class_names[i]
		
		if n.is_empty():
			continue
			
		var file_name: String = "%s%s%s.%s" % [
			file_prefix,
			_GrindleCodeGen.call("to_silent_snake", n),
			file_suffix,
			_GD
		]
		var file: String = "%s/%s" % [path, file_name]
		var file_str: String = FileAccess.get_file_as_string(file)\
			if FileAccess.file_exists(file)\
			else ""
		
		if (file_str != "pass"\
			and file_str != ""\
		):
			continue
			
		var file_tmp: String = "%s.%s" % [file, _TMP]
		
		new_files.push_back(file_tmp)
		
		var fa: FileAccess = FileAccess.open(file_tmp, FileAccess.WRITE)
		var content: String = _GrindleCodeGen.call(
			"generate_t_variant_from_template",
			template,
			n,
			i,
			code_gen_opt,
		)
		
		if fa:
			fa.store_string(content)
			fa.close()
	
	return new_files
	

func _get_dangling_persona_files(
	path: String, file_prefix: String, class_names: PackedStringArray
) -> PackedStringArray:
	var all_files: PackedStringArray = DirAccess.get_files_at(path)
	var class_names_file_name_arr: PackedStringArray = (class_names as Array[String]).map(
		func(v: String) -> String:
			var file_name: String = "%s%s.%s" % [
				file_prefix,
				_GrindleCodeGen.call("to_silent_snake", v),
				_GD
			]
			
			return file_name
	)
	var dangling_files: PackedStringArray = []
	
	for n: String in all_files:
		if n.is_empty() or n.ends_with(".uid") or n.ends_with(".%s" % _TMP):
			continue
		
		var content: String = FileAccess.get_file_as_string("%s/%s" % [path, n])
		
		if (content.strip_edges() == ""
			or content.strip_edges() == "pass"
		):
			continue
		
		if not class_names_file_name_arr.has(n):
			dangling_files.push_back("%s/%s" % [path, n])
	
	return dangling_files
	
	
func _remove_between(arr: PackedStringArray, from: int, to: int) -> PackedStringArray:
	var first_arr: PackedStringArray = arr.slice(0, from + 1)
	var second_arr: PackedStringArray = arr.slice(to, arr.size())
	
	first_arr.append_array(second_arr)
	
	return first_arr


func _do_lines_replacement(
	file_lines: PackedStringArray,
	template: String,
	names: PackedStringArray,
	start_marker: String,
	end_marker: String,
	opt: Dictionary = {},
) -> PackedStringArray:
	var lines: PackedStringArray = file_lines.duplicate()
	var blocks: PackedStringArray = _GrindleCodeGen.call(
		"generate_t_variants_from_template",
		template,
		names,
		opt,
	)
	var blocks_string: String = "\n".join(blocks)
	var start_i: int = -1
	var end_i: int = -1
	
	for i: int in range(lines.size()):
		var stripped: String = lines[i].strip_edges()
		if stripped == start_marker:
			start_i = i
			continue
		if stripped == end_marker:
			end_i = i
			continue
		if start_i != -1 and end_i != -1:
			break
	
	if start_i == -1:
		printerr(
			'%s Start marker "%s" not found in: %s.' % [_get_log_prefix(), start_marker.strip_edges(), lines]
		)
		
		return []
	if end_i == -1:
		printerr(
			'%s End marker "%s" not found in: %s.' % [_get_log_prefix(), end_marker.strip_edges(), lines]
		)
		
		return []
	
	
	lines = _remove_between(
		lines,
		start_i,
		end_i,
	)
	
	end_i = -1
		
	for i: int in range(lines.size()):
		var stripped: String = lines[i].strip_edges()
		if stripped == end_marker:
			end_i = i
			break
			
	lines.insert(
		end_i,
		blocks_string
	)
	
	return lines
	
	
func _blank_out_duplicates(arr: PackedStringArray) -> PackedStringArray:
	var d_arr: PackedStringArray = arr.duplicate()
	var seen: Dictionary[String, bool] = {}
	
	for i: int in range(d_arr.size()):
		var s: String = d_arr[i]
		
		if seen.has(s):
			d_arr[i] = ""
		else:
			seen[s] = true
		
	return d_arr
	

func _get_log_prefix() -> String:
	return "[opt/res]"
	

func _core_files_are_generated() -> bool:
	var all_files_exist: bool = true
	
	for f: String in _ALL_CORE_FILES:
		var moved_file: String = "%s/%s/%s.%s" % [_PATH_GEN, _FOLDER_CORE, f, _GD]
		
		if not FileAccess.file_exists(moved_file):
			all_files_exist = false
			
			break
	
	return all_files_exist


func _generate_missing_tmp_core_files() -> PackedStringArray:
	DirAccess.make_dir_recursive_absolute("%s/%s" % [_PATH_GEN, _FOLDER_CORE])
	
	var tmp_files: PackedStringArray = []
	
	for f: String in _ALL_CORE_FILES:
		var moved_file: String = "%s/%s/%s.%s" % [_PATH_GEN, _FOLDER_CORE, f, _GD]
		
		if FileAccess.file_exists(moved_file):
			continue
			
		var non_moved_file: String = "%s/%s/%s.%s.%s" % [
			_PATH_ADDON, _FOLDER_CORE, f, _GD, _TXT
		]
		var moved_file_tmp: String = "%s/%s/%s.%s.%s" % [
			_PATH_GEN, _FOLDER_CORE, f, _GD, _TMP
		]
		var content: String = FileAccess.get_file_as_string(non_moved_file)
		var fa: FileAccess = FileAccess.open(moved_file_tmp, FileAccess.WRITE)
		
		if fa:
			fa.store_string(content)
			fa.close()
		
		tmp_files.push_back(moved_file_tmp)
			
	return tmp_files
	
static func _get_variant_type_name(thing: Variant) -> StringName:
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

const _ALL_VARIANT_CLASS_NAMES: PackedStringArray = ["bool", "int", "float", "String", "Vector2", "Vector2i", "Rect2", "Rect2i", "Vector3", "Vector3i", "Transform2D", "Vector4", "Vector4i", "Plane", "Quaternion", "AABB", "Basis", "Transform3D", "Projection", "Color", "StringName", "NodePath", "RID", "Object", "Callable", "Signal", "Dictionary", "Array", "PackedByteArray", "PackedInt32Array", "PackedInt64Array", "PackedFloat32Array", "PackedFloat64Array", "PackedStringArray", "PackedVector2Array", "PackedVector3Array", "PackedColorArray", "PackedVector4Array"] 
const _ALL_BUILT_IN_OBJECT_CLASS_NAMES: PackedStringArray = ["AESContext", "AStar2D", "AStar3D", "AStarGrid2D", "AcceptDialog", "AnimatableBody2D", "AnimatableBody3D", "AnimatedSprite2D", "AnimatedSprite3D", "AnimatedTexture", "Animation", "AnimationLibrary", "AnimationNode", "AnimationNodeAdd2", "AnimationNodeAdd3", "AnimationNodeAnimation", "AnimationNodeBlend2", "AnimationNodeBlend3", "AnimationNodeBlendSpace1D", "AnimationNodeBlendSpace2D", "AnimationNodeBlendTree", "AnimationNodeExtension", "AnimationNodeOneShot", "AnimationNodeOutput", "AnimationNodeStateMachine", "AnimationNodeStateMachinePlayback", "AnimationNodeStateMachineTransition", "AnimationNodeSub2", "AnimationNodeSync", "AnimationNodeTimeScale", "AnimationNodeTimeSeek", "AnimationNodeTransition", "AnimationPlayer", "AnimationRootNode", "AnimationTree", "Area2D", "Area3D", "ArrayMesh", "ArrayOccluder3D", "AspectRatioContainer", "AtlasTexture", "AudioBusLayout", "AudioEffect", "AudioEffectAmplify", "AudioEffectBandLimitFilter", "AudioEffectBandPassFilter", "AudioEffectCapture", "AudioEffectChorus", "AudioEffectCompressor", "AudioEffectDelay", "AudioEffectDistortion", "AudioEffectEQ", "AudioEffectEQ10", "AudioEffectEQ21", "AudioEffectEQ6", "AudioEffectFilter", "AudioEffectHardLimiter", "AudioEffectHighPassFilter", "AudioEffectHighShelfFilter", "AudioEffectInstance", "AudioEffectLimiter", "AudioEffectLowPassFilter", "AudioEffectLowShelfFilter", "AudioEffectNotchFilter", "AudioEffectPanner", "AudioEffectPhaser", "AudioEffectPitchShift", "AudioEffectRecord", "AudioEffectReverb", "AudioEffectSpectrumAnalyzer", "AudioEffectStereoEnhance", "AudioListener2D", "AudioListener3D", "AudioSample", "AudioSamplePlayback", "AudioServer", "AudioStream", "AudioStreamGenerator", "AudioStreamInteractive", "AudioStreamMP3", "AudioStreamMicrophone", "AudioStreamOggVorbis", "AudioStreamPlayback", "AudioStreamPlaybackOggVorbis", "AudioStreamPlaybackResampled", "AudioStreamPlayer", "AudioStreamPlayer2D", "AudioStreamPlayer3D", "AudioStreamPlaylist", "AudioStreamPolyphonic", "AudioStreamRandomizer", "AudioStreamSynchronized", "AudioStreamWAV", "BackBufferCopy", "BaseButton", "BitMap", "Bone2D", "BoneAttachment3D", "BoneMap", "BoxContainer", "BoxMesh", "BoxOccluder3D", "BoxShape3D", "Button", "ButtonGroup", "CPUParticles2D", "CPUParticles3D", "CSGBox3D", "CSGCombiner3D", "CSGCylinder3D", "CSGMesh3D", "CSGPolygon3D", "CSGSphere3D", "CSGTorus3D", "CallbackTweener", "Camera2D", "Camera3D", "CameraAttributes", "CameraAttributesPhysical", "CameraAttributesPractical", "CameraFeed", "CameraServer", "CameraTexture", "CanvasGroup", "CanvasItemMaterial", "CanvasLayer", "CanvasModulate", "CanvasTexture", "CapsuleMesh", "CapsuleShape2D", "CapsuleShape3D", "CenterContainer", "CharFXTransform", "CharacterBody2D", "CharacterBody3D", "CheckBox", "CheckButton", "CircleShape2D", "ClassDB", "CodeEdit", "CodeHighlighter", "CollisionPolygon2D", "CollisionPolygon3D", "CollisionShape2D", "CollisionShape3D", "ColorPalette", "ColorPicker", "ColorPickerButton", "ColorRect", "Compositor", "CompositorEffect", "CompressedCubemap", "CompressedCubemapArray", "CompressedTexture2D", "CompressedTexture2DArray", "CompressedTexture3D", "ConcavePolygonShape2D", "ConcavePolygonShape3D", "ConeTwistJoint3D", "ConfigFile", "ConfirmationDialog", "Container", "Control", "ConvexPolygonShape2D", "ConvexPolygonShape3D", "Crypto", "CryptoKey", "Cubemap", "CubemapArray", "Curve", "Curve2D", "Curve3D", "CurveTexture", "CurveXYZTexture", "CylinderMesh", "CylinderShape3D", "DTLSServer", "DampedSpringJoint2D", "Decal", "DirectionalLight2D", "DirectionalLight3D", "ENetConnection", "ENetMultiplayerPeer", "EncodedObjectAsID", "Engine", "EngineDebugger", "EngineProfiler", "Environment", "Expression", "ExternalTexture", "FBXDocument", "FBXState", "FastNoiseLite", "FileDialog", "FlowContainer", "FogMaterial", "FogVolume", "FontFile", "FontVariation", "FramebufferCacheRD", "GDExtension", "GDScript", "GLTFAccessor", "GLTFAnimation", "GLTFBufferView", "GLTFCamera", "GLTFDocument", "GLTFDocumentExtension", "GLTFDocumentExtensionConvertImporterMesh", "GLTFLight", "GLTFMesh", "GLTFNode", "GLTFObjectModelProperty", "GLTFPhysicsBody", "GLTFPhysicsShape", "GLTFSkeleton", "GLTFSkin", "GLTFSpecGloss", "GLTFState", "GLTFTexture", "GLTFTextureSampler", "GPUParticles2D", "GPUParticles3D", "GPUParticlesAttractorBox3D", "GPUParticlesAttractorSphere3D", "GPUParticlesAttractorVectorField3D", "GPUParticlesCollisionBox3D", "GPUParticlesCollisionHeightField3D", "GPUParticlesCollisionSDF3D", "GPUParticlesCollisionSphere3D", "Generic6DOFJoint3D", "Geometry2D", "Geometry3D", "GeometryInstance3D", "Gradient", "GradientTexture1D", "GradientTexture2D", "GraphEdit", "GraphElement", "GraphFrame", "GraphNode", "GridContainer", "GridMap", "GrooveJoint2D", "HBoxContainer", "HFlowContainer", "HMACContext", "HScrollBar", "HSeparator", "HSlider", "HSplitContainer", "HTTPClient", "HTTPRequest", "HashingContext", "HeightMapShape3D", "HingeJoint3D", "Image", "ImageFormatLoaderExtension", "ImageTexture", "ImageTexture3D", "ImmediateMesh", "ImporterMesh", "ImporterMeshInstance3D", "InputEventAction", "InputEventJoypadButton", "InputEventJoypadMotion", "InputEventKey", "InputEventMIDI", "InputEventMagnifyGesture", "InputEventMouseButton", "InputEventMouseMotion", "InputEventPanGesture", "InputEventScreenDrag", "InputEventScreenTouch", "InputEventShortcut", "InputMap", "IntervalTweener", "ItemList", "JNISingleton", "JSON", "JSONRPC", "JavaClass", "JavaClassWrapper", "JavaObject", "KinematicCollision2D", "KinematicCollision3D", "Label", "Label3D", "LabelSettings", "LightOccluder2D", "LightmapGI", "LightmapGIData", "LightmapProbe", "LightmapperRD", "Line2D", "LineEdit", "LinkButton", "LookAtModifier3D", "MainLoop", "MarginContainer", "Marker2D", "Marker3D", "Marshalls", "Material", "MenuBar", "MenuButton", "Mesh", "MeshConvexDecompositionSettings", "MeshDataTool", "MeshInstance2D", "MeshInstance3D", "MeshLibrary", "MeshTexture", "MethodTweener", "MissingNode", "MissingResource", "MobileVRInterface", "MovieWriter", "MultiMesh", "MultiMeshInstance2D", "MultiMeshInstance3D", "MultiplayerAPIExtension", "MultiplayerPeerExtension", "MultiplayerSpawner", "MultiplayerSynchronizer", "Mutex", "NativeMenu", "NavigationAgent2D", "NavigationAgent3D", "NavigationLink2D", "NavigationLink3D", "NavigationMesh", "NavigationMeshGenerator", "NavigationMeshSourceGeometryData2D", "NavigationMeshSourceGeometryData3D", "NavigationObstacle2D", "NavigationObstacle3D", "NavigationPathQueryParameters2D", "NavigationPathQueryParameters3D", "NavigationPathQueryResult2D", "NavigationPathQueryResult3D", "NavigationPolygon", "NavigationRegion2D", "NavigationRegion3D", "NinePatchRect", "Node", "Node2D", "Node3D", "NoiseTexture2D", "NoiseTexture3D", "ORMMaterial3D", "OS", "Object", "OccluderInstance3D", "OccluderPolygon2D", "OfflineMultiplayerPeer", "OggPacketSequence", "OggPacketSequencePlayback", "OmniLight3D", "OpenXRAPIExtension", "OpenXRAction", "OpenXRActionBindingModifier", "OpenXRActionMap", "OpenXRActionSet", "OpenXRAnalogThresholdModifier", "OpenXRCompositionLayerCylinder", "OpenXRCompositionLayerEquirect", "OpenXRCompositionLayerQuad", "OpenXRDpadBindingModifier", "OpenXRExtensionWrapperExtension", "OpenXRHand", "OpenXRHapticVibration", "OpenXRIPBinding", "OpenXRIPBindingModifier", "OpenXRInteractionProfile", "OpenXRInteractionProfileMetadata", "OpenXRInterface", "OpenXRVisibilityMask", "OptimizedTranslation", "OptionButton", "PCKPacker", "PackedDataContainer", "PackedScene", "PacketPeerDTLS", "PacketPeerExtension", "PacketPeerStream", "PacketPeerUDP", "Panel", "PanelContainer", "PanoramaSkyMaterial", "Parallax2D", "ParallaxBackground", "ParallaxLayer", "ParticleProcessMaterial", "Path2D", "Path3D", "PathFollow2D", "PathFollow3D", "Performance", "PhysicalBone2D", "PhysicalBone3D", "PhysicalBoneSimulator3D", "PhysicalSkyMaterial", "PhysicsDirectBodyState2DExtension", "PhysicsDirectBodyState3DExtension", "PhysicsDirectSpaceState2DExtension", "PhysicsDirectSpaceState3DExtension", "PhysicsMaterial", "PhysicsPointQueryParameters2D", "PhysicsPointQueryParameters3D", "PhysicsRayQueryParameters2D", "PhysicsRayQueryParameters3D", "PhysicsServer2DExtension", "PhysicsServer2DManager", "PhysicsServer3DExtension", "PhysicsServer3DManager", "PhysicsServer3DRenderingServerHandler", "PhysicsShapeQueryParameters2D", "PhysicsShapeQueryParameters3D", "PhysicsTestMotionParameters2D", "PhysicsTestMotionParameters3D", "PhysicsTestMotionResult2D", "PhysicsTestMotionResult3D", "PinJoint2D", "PinJoint3D", "PlaceholderCubemap", "PlaceholderCubemapArray", "PlaceholderMaterial", "PlaceholderMesh", "PlaceholderTexture2D", "PlaceholderTexture2DArray", "PlaceholderTexture3D", "PlaneMesh", "PointLight2D", "PointMesh", "Polygon2D", "PolygonOccluder3D", "PolygonPathFinder", "Popup", "PopupMenu", "PopupPanel", "PortableCompressedTexture2D", "PrimitiveMesh", "PrismMesh", "ProceduralSkyMaterial", "ProgressBar", "ProjectSettings", "PropertyTweener", "QuadMesh", "QuadOccluder3D", "RDAttachmentFormat", "RDFramebufferPass", "RDPipelineColorBlendState", "RDPipelineColorBlendStateAttachment", "RDPipelineDepthStencilState", "RDPipelineMultisampleState", "RDPipelineRasterizationState", "RDPipelineSpecializationConstant", "RDSamplerState", "RDShaderFile", "RDShaderSPIRV", "RDShaderSource", "RDTextureFormat", "RDTextureView", "RDUniform", "RDVertexAttribute", "RandomNumberGenerator", "Range", "RayCast2D", "RayCast3D", "RectangleShape2D", "RefCounted", "ReferenceRect", "ReflectionProbe", "RegEx", "RegExMatch", "RemoteTransform2D", "RemoteTransform3D", "RenderDataExtension", "RenderDataRD", "RenderSceneBuffersConfiguration", "RenderSceneBuffersExtension", "RenderSceneBuffersRD", "RenderSceneDataExtension", "RenderSceneDataRD", "Resource", "ResourceFormatLoader", "ResourceFormatSaver", "ResourceLoader", "ResourcePreloader", "ResourceSaver", "RetargetModifier3D", "RibbonTrailMesh", "RichTextEffect", "RichTextLabel", "RigidBody2D", "RigidBody3D", "RootMotionView", "SceneMultiplayer", "SceneReplicationConfig", "SceneTree", "ScriptExtension", "ScriptLanguageExtension", "ScrollContainer", "SegmentShape2D", "Semaphore", "SeparationRayShape2D", "SeparationRayShape3D", "Shader", "ShaderGlobalsOverride", "ShaderInclude", "ShaderIncludeDB", "ShaderMaterial", "ShapeCast2D", "ShapeCast3D", "Shortcut", "Skeleton2D", "Skeleton3D", "SkeletonIK3D", "SkeletonModification2D", "SkeletonModification2DCCDIK", "SkeletonModification2DFABRIK", "SkeletonModification2DJiggle", "SkeletonModification2DLookAt", "SkeletonModification2DPhysicalBones", "SkeletonModification2DStackHolder", "SkeletonModification2DTwoBoneIK", "SkeletonModificationStack2D", "SkeletonModifier3D", "SkeletonProfile", "SkeletonProfileHumanoid", "Skin", "Sky", "SliderJoint3D", "SoftBody3D", "SphereMesh", "SphereOccluder3D", "SphereShape3D", "SpinBox", "SplitContainer", "SpotLight3D", "SpringArm3D", "SpringBoneCollision3D", "SpringBoneCollisionCapsule3D", "SpringBoneCollisionPlane3D", "SpringBoneCollisionSphere3D", "SpringBoneSimulator3D", "Sprite2D", "Sprite3D", "SpriteFrames", "StandardMaterial3D", "StaticBody2D", "StaticBody3D", "StatusIndicator", "StreamPeerBuffer", "StreamPeerExtension", "StreamPeerGZIP", "StreamPeerTCP", "StreamPeerTLS", "StyleBox", "StyleBoxEmpty", "StyleBoxFlat", "StyleBoxLine", "StyleBoxTexture", "SubViewport", "SubViewportContainer", "SubtweenTweener", "SurfaceTool", "SyntaxHighlighter", "SystemFont", "TCPServer", "TabBar", "TabContainer", "TextEdit", "TextLine", "TextMesh", "TextParagraph", "TextServerAdvanced", "TextServerDummy", "TextServerExtension", "TextServerManager", "Texture", "Texture2D", "Texture2DArray", "Texture2DArrayRD", "Texture2DRD", "Texture3D", "Texture3DRD", "TextureButton", "TextureCubemapArrayRD", "TextureCubemapRD", "TextureLayered", "TextureProgressBar", "TextureRect", "Theme", "ThemeDB", "Thread", "TileData", "TileMap", "TileMapLayer", "TileMapPattern", "TileSet", "TileSetAtlasSource", "TileSetScenesCollectionSource", "Time", "Timer", "TorusMesh", "TouchScreenButton", "Translation", "TranslationDomain", "TranslationServer", "Tree", "TriangleMesh", "TubeTrailMesh", "Tween", "UDPServer", "UPNP", "UPNPDevice", "UndoRedo", "UniformSetCacheRD", "VBoxContainer", "VFlowContainer", "VScrollBar", "VSeparator", "VSlider", "VSplitContainer", "VehicleBody3D", "VehicleWheel3D", "VideoStream", "VideoStreamPlayback", "VideoStreamPlayer", "VideoStreamTheora", "ViewportTexture", "VisibleOnScreenEnabler2D", "VisibleOnScreenEnabler3D", "VisibleOnScreenNotifier2D", "VisibleOnScreenNotifier3D", "VisualInstance3D", "VisualShader", "VisualShaderNodeBillboard", "VisualShaderNodeBooleanConstant", "VisualShaderNodeBooleanParameter", "VisualShaderNodeClamp", "VisualShaderNodeColorConstant", "VisualShaderNodeColorFunc", "VisualShaderNodeColorOp", "VisualShaderNodeColorParameter", "VisualShaderNodeComment", "VisualShaderNodeCompare", "VisualShaderNodeCubemap", "VisualShaderNodeCubemapParameter", "VisualShaderNodeCurveTexture", "VisualShaderNodeCurveXYZTexture", "VisualShaderNodeCustom", "VisualShaderNodeDerivativeFunc", "VisualShaderNodeDeterminant", "VisualShaderNodeDistanceFade", "VisualShaderNodeDotProduct", "VisualShaderNodeExpression", "VisualShaderNodeFaceForward", "VisualShaderNodeFloatConstant", "VisualShaderNodeFloatFunc", "VisualShaderNodeFloatOp", "VisualShaderNodeFloatParameter", "VisualShaderNodeFrame", "VisualShaderNodeFresnel", "VisualShaderNodeGlobalExpression", "VisualShaderNodeIf", "VisualShaderNodeInput", "VisualShaderNodeIntConstant", "VisualShaderNodeIntFunc", "VisualShaderNodeIntOp", "VisualShaderNodeIntParameter", "VisualShaderNodeIs", "VisualShaderNodeLinearSceneDepth", "VisualShaderNodeMix", "VisualShaderNodeMultiplyAdd", "VisualShaderNodeOuterProduct", "VisualShaderNodeParameterRef", "VisualShaderNodeParticleAccelerator", "VisualShaderNodeParticleBoxEmitter", "VisualShaderNodeParticleConeVelocity", "VisualShaderNodeParticleEmit", "VisualShaderNodeParticleMeshEmitter", "VisualShaderNodeParticleMultiplyByAxisAngle", "VisualShaderNodeParticleOutput", "VisualShaderNodeParticleRandomness", "VisualShaderNodeParticleRingEmitter", "VisualShaderNodeParticleSphereEmitter", "VisualShaderNodeProximityFade", "VisualShaderNodeRandomRange", "VisualShaderNodeRemap", "VisualShaderNodeReroute", "VisualShaderNodeRotationByAxis", "VisualShaderNodeSDFRaymarch", "VisualShaderNodeSDFToScreenUV", "VisualShaderNodeScreenNormalWorldSpace", "VisualShaderNodeScreenUVToSDF", "VisualShaderNodeSmoothStep", "VisualShaderNodeStep", "VisualShaderNodeSwitch", "VisualShaderNodeTexture", "VisualShaderNodeTexture2DArray", "VisualShaderNodeTexture2DArrayParameter", "VisualShaderNodeTexture2DParameter", "VisualShaderNodeTexture3D", "VisualShaderNodeTexture3DParameter", "VisualShaderNodeTextureParameterTriplanar", "VisualShaderNodeTextureSDF", "VisualShaderNodeTextureSDFNormal", "VisualShaderNodeTransformCompose", "VisualShaderNodeTransformConstant", "VisualShaderNodeTransformDecompose", "VisualShaderNodeTransformFunc", "VisualShaderNodeTransformOp", "VisualShaderNodeTransformParameter", "VisualShaderNodeTransformVecMult", "VisualShaderNodeUIntConstant", "VisualShaderNodeUIntFunc", "VisualShaderNodeUIntOp", "VisualShaderNodeUIntParameter", "VisualShaderNodeUVFunc", "VisualShaderNodeUVPolarCoord", "VisualShaderNodeVaryingGetter", "VisualShaderNodeVaryingSetter", "VisualShaderNodeVec2Constant", "VisualShaderNodeVec2Parameter", "VisualShaderNodeVec3Constant", "VisualShaderNodeVec3Parameter", "VisualShaderNodeVec4Constant", "VisualShaderNodeVec4Parameter", "VisualShaderNodeVectorCompose", "VisualShaderNodeVectorDecompose", "VisualShaderNodeVectorDistance", "VisualShaderNodeVectorFunc", "VisualShaderNodeVectorLen", "VisualShaderNodeVectorOp", "VisualShaderNodeVectorRefract", "VisualShaderNodeWorldPositionFromDepth", "VoxelGI", "VoxelGIData", "WeakRef", "WebRTCDataChannelExtension", "WebRTCMultiplayerPeer", "WebRTCPeerConnection", "WebRTCPeerConnectionExtension", "WebSocketMultiplayerPeer", "WebSocketPeer", "Window", "World2D", "World3D", "WorldBoundaryShape2D", "WorldBoundaryShape3D", "WorldEnvironment", "X509Certificate", "XMLParser", "XRAnchor3D", "XRBodyModifier3D", "XRBodyTracker", "XRCamera3D", "XRController3D", "XRControllerTracker", "XRFaceModifier3D", "XRFaceTracker", "XRHandModifier3D", "XRHandTracker", "XRInterfaceExtension", "XRNode3D", "XROrigin3D", "XRPose", "XRPositionalTracker", "XRServer", "XRVRS", "ZIPPacker", "ZIPReader"]
