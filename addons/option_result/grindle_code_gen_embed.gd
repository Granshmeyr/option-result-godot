# GrindleCodeGen
extends RefCounted


static func generate_t_variant_from_template(
	template: String,
	class_name_str: String,
	class_name_i: int,
	opt: Dictionary[String, Variant],
) -> String:
	assert(not class_name_str.is_empty())
	
	var already_screaming_patterns: PackedStringArray = opt.get("already_screaming_patterns", [])
	var already_screaming_indices: PackedInt32Array = opt.get("already_screaming_indices", [])
	var screaming_snake: String = to_screaming_snake(class_name_str)
	var template_overrides: Array[Array] = []
	
	if already_screaming_indices.has(class_name_i): 
		for p: String in already_screaming_patterns:
			var unfitted_pattern: String = p.replace(
				"SCREAMING_SNAKE", screaming_snake
			)
			var fitted_pattern: String = p.replace(
				"SCREAMING_SNAKE", "%s_" % screaming_snake
			)
			
			template_overrides.push_back([unfitted_pattern, fitted_pattern])
		
	var silent_snake: String = to_silent_snake(class_name_str)
	var new_string: String = template\
		.replace("SCREAMING_SNAKE", screaming_snake)\
		.replace("silent_snake", silent_snake)\
		.replace("OriginalCase", class_name_str)
	
	for a: Array in template_overrides:
		var unfitted_pattern: String = a[0]
		var fitted_pattern: String = a[1]
		
		new_string = new_string.replace(unfitted_pattern, fitted_pattern)
	
	return new_string
		

static func generate_t_variants_from_template(
	template: String,
	class_names: PackedStringArray,
	opt: Dictionary[String, Variant] = {},
) -> PackedStringArray:
	var blocks: PackedStringArray = []
	var already_screaming_patterns: PackedStringArray = opt.get(
		"already_screaming_patterns",
		PackedStringArray()
	)
	var already_screaming_indices: PackedInt32Array = opt.get(
		"already_screaming_indices",
		PackedInt32Array()
	)
	
	for i: int in range(class_names.size()):
		if class_names[i].is_empty():
			continue
	
		var template_overrides: Array[Array] = []
		var screaming_snake: String = to_screaming_snake(class_names[i])
		
		if already_screaming_indices.has(i):
			for p: String in already_screaming_patterns:
				var unfitted_pattern: String = p.replace(
					"SCREAMING_SNAKE", screaming_snake
				)
				var fitted_pattern: String = p.replace(
					"SCREAMING_SNAKE", "%s_" % screaming_snake
				)
				
				template_overrides.push_back(
					[unfitted_pattern, fitted_pattern]	
				)
		
		var silent_snake: String = to_silent_snake(class_names[i])
		var new_block: String = template\
			.replace("SCREAMING_SNAKE", screaming_snake)\
			.replace("silent_snake", silent_snake)\
			.replace("OriginalCase", class_names[i])
		
		for a: Array in template_overrides:
			var unfitted_pattern: String = a[0]
			var fitted_pattern: String = a[1]
			
			new_block = new_block.replace(unfitted_pattern, fitted_pattern)
		
		blocks.push_back(new_block)
	
	return blocks
	

static func to_screaming_snake(input: String) -> String:
	var pattern: RegEx = RegEx.new()
	
	pattern.compile(r"(?:[23]D(?![a-z]))|[0-9]+|[A-Z]+(?![a-z])|[A-Z]?[a-z]+")
	
	var matches: Array[RegExMatch] = pattern.search_all(input)
	var tokens: Array[String] = []
	
	for match: RegExMatch in matches:
		tokens.append(match.get_string().to_upper())
	
	return "_".join(tokens)	
	
static func to_silent_snake(input: String) -> String:
	var pattern: RegEx = RegEx.new()
	
	pattern.compile(r"(?:[23]D(?![a-z]))|[0-9]+|[A-Z]+(?![a-z])|[A-Z]?[a-z]+")
	
	var matches: Array[RegExMatch] = pattern.search_all(input)
	var tokens: Array[String] = []
	
	for match: RegExMatch in matches:
		tokens.append(match.get_string().to_lower())
	
	return "_".join(tokens)	
