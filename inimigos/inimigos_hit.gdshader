shader_type canvas_item;


uniform bool _is_active = false;

void fragment() {
	if ( _is_active == true){
		vec4 previus_color = texture(TEXTURE, UV);
		COLOR = vec4(1.0, 0.0, 0.0, previus_color.a);
	}

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
