extends Node


func _ready() -> void:
	var sprite: String = Chain.to(&"String").do(
		Chain.start(
			_load_texture("player%s" % ".png" if randi_range(0, 100) < 70 else ".txt")
		),
		RString.map_to_c(func (texture: String) -> String: return "Sprite from %s" % texture),
		RString.map_to_c(func (spr: String) -> String: return "%s (scaled x2)" % spr),
		RString.and_then_to_c(_validate_sprite),
		RString.map_to_c(func (spr: String) -> String: return "%s -> ready to render" % spr),
		RString.unwrap_or_else_c(
			func (err: String) -> String: return "Defaulted to fallback sprite (error: %s)" % err
		),
	)
	
	print("Result chain result:\n\t%s" % sprite)


func _load_texture(path: String) -> RString:
	var dot_i: int = path.find(".")
	var ext: String = "." + path[dot_i + 1] + path[dot_i + 2] + path[dot_i + 3]
	return RString.Ok("texture %s loaded" % path)\
		if ext == ".png"\
		else RString.Err("Unsupported texture format '%s'" % ext)
		
		
func _validate_sprite(sprite: String) -> RString:
	return RString.Ok(sprite)\
		if randi_range(0, 100) < 70\
		else RString.Err("Sprite failed validation.")
